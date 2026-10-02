# Cap nhat page_css/page_js cua cac view + chen khai bao moi
$ErrorActionPreference = 'Stop'
$V = 'C:\Projects\valse_v1\app\views'

function Edit-File([string]$rel, [scriptblock]$fn) {
  $p = Join-Path $V $rel
  $t = [IO.File]::ReadAllText($p)
  $t = & $fn $t
  [IO.File]::WriteAllText($p, $t, [Text.UTF8Encoding]::new($false))
  Write-Output "OK $rel"
}

function AddPageCss([string]$block) {
  {
    param($t)
    if ($t -match 'content_for :page_css') { return $t }
    "`r`n<% content_for :page_css do %>`r`n$block`r`n<% end %>`r`n" + $t
  }.GetNewClosure()
}

# --- contact.html.erb: gom page_css thanh 1 file, doi page_js ---
Edit-File 'pages\contact.html.erb' { param($t)
  $t = $t -replace '(?s)<% content_for :page_css do %>.*?<% end %>', "<% content_for :page_css do %>`r`nguest/pages/contact`r`n<% end %>"
  $t = $t -replace '(?m)^metform/htm\s*$', 'forms/htm'
  $t = $t -replace '(?m)^wp/react\.min\s*$', 'vendor/react/react.min'
  $t = $t -replace '(?m)^wp/react-dom\.min\s*$', 'vendor/react/react-dom.min'
  $t = $t -replace '(?m)^wp/escape-html\.min\s*$', 'vendor/react/escape-html.min'
  $t = $t -replace '(?m)^wp/element\.min\s*$', 'vendor/react/element.min'
  $t = $t -replace '(?m)^metform/app\s*$', 'forms/app'
  $t
}

# --- pricing ---
Edit-File 'pages\pricing.html.erb' { param($t)
  $t = $t -replace '(?s)<% content_for :page_css do %>.*?<% end %>', "<% content_for :page_css do %>`r`nguest/pages`r`nguest/pages/pricing`r`n<% end %>"
  $t
}

# --- courses/index ---
Edit-File 'courses\index.html.erb' { param($t)
  $t = $t -replace '(?s)<% content_for :page_css do %>.*?<% end %>', "<% content_for :page_css do %>`r`nguest/courses`r`nguest/courses/index`r`n<% end %>"
  $t = $t.Replace("card_icons = %w[icon-01 icon-02 icon-04 icon-03 icon-05 icon-06 icon-07 icon-08]", "card_icons = %w[instrument-guitar instrument-violin instrument-piano instrument-drums instrument-05 instrument-06 instrument-07 instrument-08]")
  $t = $t.Replace('<% icon_src = i % card_icons.length < 4 ? "/app/images/2024/08/#{icon}.png" : "/app/images/2024/10/#{icon}.png" %>', '<% icon_src = image_path("icons/#{icon}.png") %>')
  $t = $t -replace '<% icon_src = i % card_icons\.length < 4 \? "[^"]*#\{icon\}\.png" : "[^"]*#\{icon\}\.png" %>', '<% icon_src = image_path("icons/#{icon}.png") %>'
  $t = $t.Replace('(CSS: app/post-1111.css)', '(CSS: guest/courses/index.css)')
  $t
}

# --- courses/show ---
Edit-File 'courses\show.html.erb' { param($t)
  $t = $t -replace '(?s)<% content_for :page_css do %>.*?<% end %>', "<% content_for :page_css do %>`r`nguest/courses`r`nguest/courses/show`r`n<% end %>"
  $t = $t -replace '(?m)^jkit/accordion\s*$', 'widgets/accordion'
  $t
}

# --- products/index ---
Edit-File 'products\index.html.erb' { param($t)
  $t = $t -replace '(?m)^theme/app/posts/post-1111\s*$', 'guest/courses/index'
  $t = $t -replace '(?m)^valse/products\s*$', 'guest/products'
  $t = $t -replace '\s*<% content_for :skip_fa_shim_js, "1" %>', ''
  $t = $t.Replace('khong co widget`r`n    circle cua ekit -> bo 4 script mac dinh gan o footer', 'bo script fun-fact/cute-alert khong dung tren trang nay')
  $t = $t -replace '(?s)<%# Trang khong co counter[^>]*?->[^%]*?%>', ''
  $t
}

# --- posts: chen page_css ---
Edit-File 'posts\index.html.erb' (AddPageCss 'guest/posts')
Edit-File 'posts\show.html.erb' (AddPageCss 'guest/posts')

# --- testimonials ---
Edit-File 'pages\testimonials.html.erb' (AddPageCss 'guest/pages')

# --- auth ---
Edit-File 'sessions\new.html.erb' (AddPageCss 'guest/auth')
Edit-File 'registrations\new.html.erb' (AddPageCss 'guest/auth')
Edit-File 'passwords\new.html.erb' (AddPageCss 'guest/auth')
Edit-File 'passwords\edit.html.erb' (AddPageCss 'guest/auth')

# --- man hinh can dang nhap (layout theme) -> admin/ ---
Edit-File 'profiles\show.html.erb' (AddPageCss 'admin/profile')
Edit-File 'teachers\index.html.erb' (AddPageCss 'admin/schedule')
Edit-File 'teachers\show.html.erb' (AddPageCss 'admin/schedule')
Edit-File 'bookings\index.html.erb' (AddPageCss 'admin/schedule')
Edit-File 'availabilities\index.html.erb' (AddPageCss 'admin/schedule')
Edit-File 'availabilities\new.html.erb' (AddPageCss 'admin/schedule')
Edit-File 'availabilities\edit.html.erb' (AddPageCss 'admin/schedule')
Write-Output '=== Xong views ==='