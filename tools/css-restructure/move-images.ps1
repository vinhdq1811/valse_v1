# Chuyen anh tu public/wp-content -> app/assets/images theo images.tsv
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$imgRoot = Join-Path $root 'app\assets\images'
$rows = Get-Content (Join-Path $PSScriptRoot 'images.tsv') -Encoding UTF8 | Where-Object { $_ -match "`t" } | ForEach-Object {
  $i = $_.IndexOf("`t"); [pscustomobject]@{ Old = $_.Substring(0, $i); New = $_.Substring($i + 1) }
}
$moved = 0; $missing = @()
foreach ($r in $rows) {
  $src = Join-Path $root ('public\wp-content\' + ($r.Old -replace '/', '\'))
  $dst = Join-Path $imgRoot ($r.New -replace '/', '\')
  if (Test-Path -LiteralPath $src) {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    Move-Item -LiteralPath $src -Destination $dst -Force
    $moved++
  } else { $missing += $r.Old }
}
# circle.svg tu app assets
$circle = Join-Path $imgRoot 'elementor\circle.svg'
if (Test-Path -LiteralPath $circle) {
  New-Item -ItemType Directory -Force -Path (Join-Path $imgRoot 'decor') | Out-Null
  Move-Item -LiteralPath $circle (Join-Path $imgRoot 'decor\circle-text.svg') -Force
  Write-Output 'da chuyen elementor/circle.svg -> decor/circle-text.svg'
}
# con lai trong wp-content = khong dung -> xoa ca thu
$wp = Join-Path $root 'public\wp-content'
if (Test-Path $wp) { Remove-Item -Recurse -Force $wp; Write-Output 'da xoa public/wp-content' }
Write-Output "=== Da chuyen $moved anh; khong tim thay $($missing.Count) ==="
$missing | ForEach-Object { Write-Output "  thieu: $_" }