# frozen_string_literal: true

# Builds shared layout partials (head + header, footer) from the static
# Musicali courses page, rewrites nav links across all static pages, and
# patches them in place.
#
# One-off script:
#   docker compose exec web ruby scripts/build_musicali_layout.rb

require "fileutils"

ROOT = File.expand_path("..", __dir__)
PUBLIC = File.join(ROOT, "public")

def decode_cf_emails(html)
  html.gsub(%r{<span class="__cf_email__"[^>]*>.*?</span>}) do |span|
    encoded = span[/data-cfemail="([0-9a-f]+)"/, 1]
    next span unless encoded

    key = encoded[0, 2].to_i(16)
    encoded[2..].scan(/../).map { |byte| (byte.to_i(16) ^ key).chr }.join
  end
end

def fix_nav(html)
  html = html.gsub('href="/services/"', 'href="/courses"')
  html = html.gsub(
    '<a href="/course-detail/">Course Detail</a>',
    '<a href="/courses?category=course">Khóa học Piano</a>'
  )
  html = html.gsub(
    '>Khóa học Piano</a></li>',
    %(>Khóa học Piano</a></li>\n\t<li class="menu-item menu-item-type-post_type menu-item-object-page"><a href="/courses?category=sheet">Sheet nhạc</a></li>\n\t<li class="menu-item menu-item-type-post_type menu-item-object-page"><a href="/courses?category=piano">Đàn piano</a></li>)
  )
  html = html.gsub(%r{\s*<li[^>]*><a href="/about/">About</a></li>}, "")
  html = html.gsub(%r{\s*<li[^>]*><a href="/gallery/">Gallery</a></li>}, "")
  html = html.gsub(%r{\s*<li[^>]*><a href="/faq/">FAQ</a></li>}, "")
  html = html.gsub(%r{\s*<li[^>]*><a href="/our-team/">Our Team</a></li>}, "")
  html = html.gsub(%r{\s*<li[^>]*><a href="/404-2/">404</a></li>}, "")
  html = html.gsub('href="/about/"', 'href="/"')
  html = html.gsub('href="/gallery/"', 'href="/courses"')
  html = html.gsub('href="/faq/"', 'href="/pricing"')
  html = html.gsub('href="/our-team/"', 'href="/testimonials"')
  html = html.gsub('href="/404-2/"', 'href="/"')
  html = html.gsub('href="" class="jkit-nav-logo"', 'href="/" class="jkit-nav-logo"')
  html
end

src = File.binread(File.join(PUBLIC, "musicali-courses.html")).force_encoding(Encoding::UTF_8)
src = decode_cf_emails(src)

header_end = src.index("</header>") + "</header>".length
footer_start = src.index("<footer")

header = src[0, header_end]
footer = src[footer_start..]

header = header.sub(/<title>.*?<\/title>/m, "<title><%= yield :title %></title>")
header = header.sub("</head>", %(    <link rel="stylesheet" href="/valse-pages.css">\n</head>))

header = fix_nav(header)
footer = fix_nav(footer)

layout_dir = File.join(ROOT, "app/views/layouts/musicali")
FileUtils.mkdir_p(layout_dir)
File.write(File.join(layout_dir, "_header.html.erb"), header)
File.write(File.join(layout_dir, "_footer.html.erb"), footer)

layout = <<~ERB
  <%= render "layouts/musicali/header" %>
  <%= yield %>
  <%= render "layouts/musicali/footer" %>
ERB
File.write(File.join(ROOT, "app/views/layouts/musicali.html.erb"), layout)

Dir.glob(File.join(PUBLIC, "musicali-*.html")).each do |path|
  html = File.binread(path).force_encoding(Encoding::UTF_8)
  File.binwrite(path, fix_nav(decode_cf_emails(html)).dup.force_encoding(Encoding::UTF_8))
  puts "patched #{File.basename(path)}"
end

puts "header partial: #{header.bytesize} bytes"
puts "footer partial: #{footer.bytesize} bytes"
puts "DONE"
