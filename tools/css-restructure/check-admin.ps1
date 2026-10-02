# Test admin: login -> quet asset cac trang admin + test form lien he
$ErrorActionPreference = 'Continue'
$base = 'http://127.0.0.1:3000'
$sess = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# lay token CSRF tu trang login
$loginPage = Invoke-WebRequest -Uri "$base/session/new" -WebSession $sess -UseBasicParsing
$token = ([regex]::Match($loginPage.Content, 'name="csrf-token" content="([^"]+)"')).Groups[1].Value
$tsf = ([regex]::Match($loginPage.Content, 'name="authenticity_token" value="([^"]+)"')).Groups[1].Value

$body = @{ authenticity_token = $tsf; email_address = 'admin@valse.test'; password = 'password123' }
$login = Invoke-WebRequest -Uri "$base/session" -Method Post -Body $body -WebSession $sess -UseBasicParsing -MaximumRedirection 5
Write-Output ("login => " + $login.StatusCode)

$adminPages = @('/admin', '/admin/posts', '/admin/testimonials', '/admin/categories', '/admin/tags', '/admin/enrollments', '/admin/lessons', '/admin/users', '/admin/settings/edit')
$bad = New-Object System.Collections.Generic.HashSet[string]
foreach ($p in $adminPages) {
  try {
    $html = (Invoke-WebRequest -Uri "$base$p" -WebSession $sess -UseBasicParsing -TimeoutSec 30 -MaximumRedirection 5).Content
    $urls = [regex]::Matches($html, '(?:src|href)="(/assets/[^"]+|/images/[^"]+|/wp-content[^"]*)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    foreach ($u in $urls) {
      try {
        $resp = Invoke-WebRequest -Uri "$base$u" -UseBasicParsing -Method Head -TimeoutSec 20 -WebSession $sess
        if ($resp.StatusCode -ne 200) { [void]$bad.Add("$p $u -> $($resp.StatusCode)") }
      } catch { [void]$bad.Add("$p $u -> ERR") }
    }
    Write-Output "$p : 200, $($urls.Count) asset"
  } catch {
    $code = try { [int]$_.Exception.Response.StatusCode } catch { 'ERR' }
    Write-Output "$p => $code"
  }
}
Write-Output '=== ASSET ADMIN LOI ==='
$bad | ForEach-Object { Write-Output $_ }
if ($bad.Count -eq 0) { Write-Output 'KHONG CO LOI' }

# test form lien he (endpoint moi)
$contactPage = Invoke-WebRequest -Uri "$base/contact" -WebSession $sess -UseBasicParsing
$ctsf = ([regex]::Match($contactPage.Content, 'name="csrf-token" content="([^"]+)"')).Groups[1].Value
try {
  $r = Invoke-WebRequest -Uri "$base/api/contact-form/entries/insert/1368" -Method Post -Body @{ 'contact-name' = 'Test'; 'contact-email' = 'test@example.com'; 'contact-phone' = '0123'; 'contact-subject' = 'Kiem tra'; 'contact-message' = 'Noi dung thu' } -Headers @{ 'X-CSRF-Token' = $ctsf } -WebSession $sess -UseBasicParsing -ContentType 'application/x-www-form-urlencoded; charset=UTF-8'
  Write-Output ("form submit => " + $r.StatusCode + " : " + $r.Content.Substring(0, [Math]::Min(120, $r.Content.Length)))
} catch {
  $code = try { [int]$_.Exception.Response.StatusCode } catch { 'ERR' }
  Write-Output "form submit => $code"
}