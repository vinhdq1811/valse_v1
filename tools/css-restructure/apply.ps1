# Ap dung rename WP/Elementor -> ngu nghia cho danh sach file.
# Usage: powershell -File apply.ps1 -ListFile <file-txt-chua-danh-sach-duong-dan>
param(
  [string[]]$Files,
  [string]$ListFile
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

# ---------- literals (thay chuoi thuan, chay truoc) ----------
$literals = [ordered]@{
  '\/wp-content\/plugins\/elementor\/assets\/' = '\/assets\/framework\/'
  '\/wp-admin\/admin-ajax.php'                 = '\/api\/endpoint'
  '\/wp-content\/uploads'                      = '\/images'
  'elementor/frontend/init'                    = 'app/frontend/init'
  'frontend/element_ready/'                    = 'app/element_ready/'
  'elementor/lazyload/observe'                 = 'app/lazyload/observe'
  'wp-json/metform/v1/forms/views/'            = 'api/contact-form/forms/views/'
  'wp-json/metform/v1/entries/insert/'         = 'api/contact-form/entries/insert/'
  'X-WP-Nonce'                                 = 'X-Api-Nonce'
  'mf-response-props-id-'                      = 'form-response-id-'
  'menu-primary-menu-desktop-01'               = 'nav-desktop-01'
  'menu-primary-menu-desktop-02'               = 'nav-desktop-02'
  'menu-primary-menu-phone'                    = 'nav-mobile-01'
  '--e-global-typography-'                     = '--font-'
  '--e-global-color-'                          = '--color-'
  '--e-con-grid-template-columns'              = '--section-grid-columns'
  '--e-con-grid-template-rows'                 = '--section-grid-rows'
  '--e-con-transform-'                         = '--fx-con-transform-'
  '--e-transform-'                             = '--fx-transform-'
  '--e-column-margin-'                         = '--col-margin-'
  '--e-icon-list-icon-'                        = '--link-list-icon-'
  '--e-social-icon-icon-color'                 = '--social-link-icon-color'
  '--jkit-'                                    = '--ui-'
  '--jeg-'                                     = '--ui-'
  'jkitNumber'                                 = 'uiNumber'
  'jkitN'                                      = 'uiN'
  'metform-responseOpen'                       = 'contact-form-response-open'
  'metform-responseClose'                      = 'contact-form-response-close'
  'glyph-jeg-kit-logo-solid'                   = 'glyph-brand-logo-solid'
  'glyph-jeg-kit-logo'                         = 'glyph-brand-logo'
  'glyph-ekit-light'                           = 'glyph-light'
  'image_path("elementor/circle.svg")'         = "image_path('decor/circle-text.svg')"
}

# ---------- regex rules (chay sau literals, truoc tokens) ----------
$regexRules = @(
  @{ Pattern = 'wp-image-([0-9]+)';            Replace = 'image-$1' },
  @{ Pattern = 'jeg_module_[0-9]+__';          Replace = 'js-mod-0' },
  @{ Pattern = 'jeg_module_[0-9]+_([0-9]+)_';  Replace = 'js-mod-$1' },
  @{ Pattern = '--container-widget-([a-z-]+)'; Replace = '--block-widget-$1' },
  @{ Pattern = 'metform-wrap-fb[0-9a-z-]+';    Replace = 'contact-form-wrap' },
  @{ Pattern = '\s+(icon-position-|el-animation-|jkit-animation-)(?=[\s"{}:,])'; Replace = '' }
)

# ---------- prefix fallback (chay SAU token pass, bat token con sot) ----------
$prefixRules = @(
  @{ P = '(?<![A-Za-z0-9_-])jkit-(?=[a-z0-9_])';    R = 'ui-' },
  @{ P = '(?<![A-Za-z0-9_-])jkit_(?=[a-z0-9_])';    R = 'ui_' },
  @{ P = '(?<![A-Za-z0-9_-])jeg-(?=[a-z0-9_])';     R = 'ui-' },
  @{ P = '(?<![A-Za-z0-9_-])jeg_(?=[a-z0-9_])';     R = 'ui_' },
  @{ P = '(?<![A-Za-z0-9_-])jki-(?=[a-z0-9_])';     R = 'glyph-' },
  @{ P = '(?<![A-Za-z0-9_-])mf-(?=[a-z0-9])';       R = 'cf-' },
  @{ P = '(?<![A-Za-z0-9_-])mf_(?=[a-z0-9_])';      R = 'cf_' },
  @{ P = '(?<![A-Za-z0-9_-])ekit[-_](?=[a-z0-9])';  R = 'ui-' },
  @{ P = '(?<![A-Za-z0-9_-])wp-(?=[a-z0-9])';       R = 'site-' },
  @{ P = '(?<![A-Za-z0-9_-])hello-(?=[a-z0-9])';    R = 'site-' },
  @{ P = '(?<![A-Za-z0-9_-])elementor(?![A-Za-z0-9_-])'; R = 'app' },
  @{ P = '(?<![A-Za-z0-9_-])el-(?=[a-z0-9_])';      R = '' }
)

# ---------- token map ----------
$tokens = Get-Content (Join-Path $PSScriptRoot 'tokens.tsv') -Encoding UTF8 |
  Where-Object { $_ -match "`t" -and $_ -notmatch '^\s*#' } | ForEach-Object {
    $i = $_.IndexOf("`t")
    [pscustomobject]@{ Old = $_.Substring(0, $i); New = $_.Substring($i + 1) }
  } | Where-Object { $_.Old -notmatch '[-_]$' } |
  Sort-Object { $_.Old.Length } -Descending

$rxCache = @{}
function Get-Rx([string]$old) {
  if (-not $rxCache.ContainsKey($old)) {
    if ($old -eq 'el-') {
      $rxCache[$old] = [regex]'(?<![A-Za-z0-9_-])el-(?=[a-z0-9_])'
    } else {
      $pat = '(?<![A-Za-z0-9_$-])' + [regex]::Escape($old) + '(?![A-Za-z0-9_$-])'
      $rxCache[$old] = [regex]::new($pat)
    }
  }
  $rxCache[$old]
}

# ---------- image map ----------
$imageRows = Get-Content (Join-Path $PSScriptRoot 'images.tsv') -Encoding UTF8 |
  Where-Object { $_ -match "`t" } | ForEach-Object {
    $i = $_.IndexOf("`t")
    [pscustomobject]@{ Old = $_.Substring(0, $i); New = $_.Substring($i + 1) }
  }

$changed = 0
if ($ListFile) { $Files = Get-Content $ListFile -Encoding UTF8 | Where-Object { $_ -and (Test-Path -LiteralPath $_) } }
foreach ($f in $Files) {
  $full = if ([IO.Path]::IsPathRooted($f)) { $f } else { Join-Path $root $f }
  if (-not (Test-Path -LiteralPath $full)) { Write-Warning "Khong tim thay: $full"; continue }
  $text = [IO.File]::ReadAllText($full)
  $orig = $text

  foreach ($k in $literals.Keys) { $text = $text.Replace($k, $literals[$k]) }
  foreach ($r in $regexRules) { $text = [regex]::Replace($text, $r.Pattern, $r.Replace) }
  foreach ($t in $tokens) { $text = (Get-Rx $t.Old).Replace($text, $t.New) }
  foreach ($p in $prefixRules) { $text = [regex]::Replace($text, $p.P, $p.R) }
  $text = $text.Replace('elementor', 'app').Replace('Elementor', 'App')

  $ext = [IO.Path]::GetExtension($full).ToLower()
  if ($ext -eq '.erb') {
    foreach ($im in $imageRows) {
      $text = $text.Replace('/wp-content/' + $im.Old, "<%= image_path('" + $im.New + "') %>")
    }
  } elseif ($ext -eq '.css') {
    $rel = [IO.Path]::GetFullPath($full).Substring(($root + '\app\assets\stylesheets\').Length)
    $depth = ($rel -split '[\\/]').Count - 2
    $prefix = ('../' * [Math]::Max($depth, 0)) + '../images/'
    foreach ($im in $imageRows) {
      $text = $text.Replace('/wp-content/' + $im.Old, $prefix + $im.New)
    }
  }

  if ($text -ne $orig) {
    [IO.File]::WriteAllText($full, $text, [Text.UTF8Encoding]::new($false))
    $changed++
    Write-Output "OK  $f"
  } else {
    Write-Output "--  (khong doi) $f"
  }
}
Write-Output "=== Da sua $changed/$($Files.Count) file ==="