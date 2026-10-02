# Ghep CSS cu -> cau truc guest/ + admin/ (giu thu tu cascade)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$ss = Join-Path $root 'app\assets\stylesheets'
function Read1($p) { [IO.File]::ReadAllText((Join-Path $ss $p)) }

New-Item -ItemType Directory -Force -Path `
  "$ss\guest\pages", "$ss\guest\courses", "$ss\guest\fonts\lora", "$ss\guest\img", "$ss\admin" | Out-Null

# ---------- flash + avatar (tu schedule.css -> shared) ----------
$sched = Read1 'valse\schedule.css'
$iFlash = $sched.IndexOf('/* ---------- Flash')
$iAvatar = $sched.IndexOf('/* ---------- Avatar')
$iTeacher = $sched.IndexOf('/* ---------- Danh s')
if ($iFlash -lt 0 -or $iAvatar -lt 0 -or $iTeacher -lt 0) { throw 'Khong tim thay moc section trong schedule.css' }
$flashAvatar = $sched.Substring($iFlash, $iTeacher - $iFlash)
$schedRest = $sched.Substring(0, $sched.IndexOf('*/') + 2) + "`r`n" + $sched.Substring($iTeacher)

# ---------- guest/style.css ----------
$order = @(
  'theme\hello-elementor\reset.css',
  'theme\hello-elementor\theme.css',
  'theme\hello-elementor\header-footer.css',
  'theme\jkit\elements\main.css',
  'theme\elementor\custom-frontend.min.css',
  'theme\elementor\posts\post-8.css',
  'theme\elementor\custom\custom-widget-icon-list.min.css',
  'theme\elementor\widgets\widget-heading.min.css',
  'theme\elementor\widgets\widget-text-path.min.css',
  'theme\elementor\animations\e-animation-shrink.min.css',
  'theme\elementor\animations\fadeInUp.min.css',
  'theme\elementor\animations\fadeIn.min.css',
  'theme\elementor\widgets\widget-image.min.css',
  'theme\elementor\widgets\widget-spacer.min.css',
  'theme\elementor\animations\slideInUp.min.css',
  'theme\elementor\widgets\widget-divider.min.css',
  'theme\elementor\custom\custom-widget-icon-box.min.css',
  'theme\fonts\lora.css',
  'theme\jkit\jkiticon\jkiticon.css',
  'theme\elementor\posts\post-1683.css',
  'theme\elementor\posts\post-678.css',
  'theme\elementor\widgets\widget-social-icons.min.css',
  'theme\elementor\custom\custom-apple-webkit.min.css',
  'valse\base.css',
  'valse\header.css',
  'jkit\tiny-slider.css'
)
$head = @"
/* =====================================================================
   Valse — guest/style.css
   CSS dung chung cho toan bo man hinh khach (guest).
   Gom: reset, bien mau/theme, khung section, hieu ung, widget chung,
   icon font, font chu, header/footer, style co ban vp-*.
   CSS rieng tung man hinh nam o guest/<controller>/... (nap qua page_css).
   ===================================================================== */

"@
$body = $head + ("body{padding-top: 0px;padding-right: 0px;padding-bottom: 0px;padding-left: 0px;}`r`n`r`n") + $flashAvatar + "`r`n"
foreach ($p in $order) { $body += "`r`n/* ---- source: $p ---- */`r`n" + (Read1 $p) + "`r`n" }

# sua url() font/img cho dung vi tri moi trong guest/
$body = $body.Replace('url(jkiticon.eot?bv8d8l#iefix)', 'url("fonts/valseicons.eot#iefix")')
$body = $body.Replace('url(jkiticon.eot?bv8d8l)', 'url("fonts/valseicons.eot")')
$body = $body.Replace('url(jkiticon.woff2?bv8d8l)', 'url("fonts/valseicons.woff2")')
$body = $body.Replace('url(jkiticon.woff?bv8d8l)', 'url("fonts/valseicons.woff")')
$body = $body.Replace('url(jkiticon.ttf?bv8d8l)', 'url("fonts/valseicons.ttf")')
$body = $body.Replace('url(jkiticon.svg?bv8d8l#jkiticon)', 'url("fonts/valseicons.svg#valseicons")')
$body = [regex]::Replace($body, 'url\((lora/[^)]+\.woff2)\)', { param($m) 'url("fonts/' + $m.Groups[1].Value + '")' })
$body = $body.Replace('url(../../img/letter-x.svg)', 'url("img/letter-x.svg")')

[IO.File]::WriteAllText((Join-Path $ss 'guest\style.css'), $body, [Text.UTF8Encoding]::new($false))

# ---------- file theo trang / controller ----------
function Put($rel, $content) {
  $p = Join-Path $ss $rel
  [IO.File]::WriteAllText($p, $content, [Text.UTF8Encoding]::new($false))
  Write-Output "tao $rel"
}
Put 'guest\pages\home.css'     (Read1 'theme\elementor\posts\post-34.css')
Put 'guest\pages\pricing.css'  (Read1 'theme\elementor\posts\post-1461.css')
Put 'guest\pages\contact.css'  ((Read1 'theme\elementor\posts\post-1349.css') + "`r`n" + (Read1 'theme\metform\metform-ui.css') + "`r`n" + (Read1 'theme\metform\style.css') + "`r`n" + (Read1 'theme\metform\cute-alert.css') + "`r`n" + (Read1 'theme\metform\text-editor.css'))
Put 'guest\pages.css'          (Read1 'valse\pages.css')
Put 'guest\courses.css'        (Read1 'valse\courses.css')
Put 'guest\courses\index.css'  (Read1 'theme\elementor\posts\post-1111.css')
Put 'guest\courses\show.css'   (Read1 'theme\elementor\posts\post-1144.css')
Put 'guest\products.css'       (Read1 'valse\products.css')
Put 'guest\posts.css'          (Read1 'valse\posts.css')
Put 'guest\auth.css'           (Read1 'valse\auth.css')
Put 'admin\style.css'          (Read1 'admin.css')
Put 'admin\actiontext.css'     (Read1 'actiontext.css')
Put 'admin\profile.css'        (Read1 'valse\profile.css')
Put 'admin\schedule.css'       $schedRest

# ---------- font & img copy ----------
Copy-Item "$ss\theme\jkit\jkiticon\jkiticon.eot"   "$ss\guest\fonts\valseicons.eot"   -Force
Copy-Item "$ss\theme\jkit\jkiticon\jkiticon.svg"   "$ss\guest\fonts\valseicons.svg"   -Force
Copy-Item "$ss\theme\jkit\jkiticon\jkiticon.ttf"   "$ss\guest\fonts\valseicons.ttf"   -Force
Copy-Item "$ss\theme\jkit\jkiticon\jkiticon.woff"  "$ss\guest\fonts\valseicons.woff"  -Force
Copy-Item "$ss\theme\jkit\jkiticon\jkiticon.woff2" "$ss\guest\fonts\valseicons.woff2" -Force
Copy-Item "$ss\theme\fonts\lora\*" "$ss\guest\fonts\lora\" -Force
Copy-Item "$ss\theme\jkit\img\letter-x.svg" "$ss\guest\img\letter-x.svg" -Force
Write-Output "=== Xong guest/ + admin/ ==="