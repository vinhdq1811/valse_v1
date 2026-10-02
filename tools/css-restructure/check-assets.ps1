# Quet asset tren tung trang, bao URL /assets/ tra ve khong phai 200
$ErrorActionPreference = 'Continue'
$pages = @('/', '/courses', '/pricing', '/contact', '/blog', '/products', '/testimonials', '/session/new', '/registration/new', '/teachers', '/bookings', '/availabilities', '/profile')
$bad = New-Object System.Collections.Generic.HashSet[string]
foreach ($p in $pages) {
  try { $html = (Invoke-WebRequest -Uri "http://127.0.0.1:3000$p" -UseBasicParsing -TimeoutSec 30).Content }
  catch { Write-Output "PAGE $p KHONG LOAD"; continue }
  $urls = [regex]::Matches($html, '(?:src|href)="(/assets/[^"]+|/images/[^"]+|/wp-content[^"]*)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($u in $urls) {
    try {
      $resp = Invoke-WebRequest -Uri "http://127.0.0.1:3000$u" -UseBasicParsing -Method Head -TimeoutSec 20
      if ($resp.StatusCode -ne 200) { [void]$bad.Add("$p $u -> $($resp.StatusCode)") }
    } catch {
      $code = try { [int]$_.Exception.Response.StatusCode } catch { 'ERR' }
      [void]$bad.Add("$p $u -> $code")
    }
  }
  Write-Output "$p : $($urls.Count) asset da quet"
}
Write-Output '=== ASSET LOI ==='
$bad | ForEach-Object { Write-Output $_ }
if ($bad.Count -eq 0) { Write-Output 'KHONG CO LOI' }