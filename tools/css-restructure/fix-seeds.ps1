$ErrorActionPreference = 'Stop'
$p = 'C:\Projects\valse_v1\db\seeds.rb'
$t = [IO.File]::ReadAllText($p)
$t = $t.Replace('img = "/wp-content/uploads/2024/08"', 'img = "photos"')
$t = $t.Replace('image: "#{img}/valse-img-01.jpg"',  'image: "photos/about-01.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-02.jpg"',  'image: "photos/about-02.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-03.jpg"',  'image: "photos/about-03.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-05.jpg"',  'image: "photos/about-04.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-012.jpg"', 'image: "photos/team-01.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-013.jpg"', 'image: "photos/team-02.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-014.jpg"', 'image: "photos/team-03.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-015.jpg"', 'image: "photos/team-04.jpg"')
$t = $t.Replace('image: "/wp-content/uploads/2024/09/valse-img-016.jpg"', 'image: "photos/studio-01.jpg"')
$t = $t.Replace('image: "/wp-content/uploads/2024/10/valse-img-017.jpg"', 'image: "photos/studio-02.jpg"')
$t = $t.Replace('image: "/wp-content/uploads/2024/10/valse-img-018.jpg"', 'image: "photos/studio-03.jpg"')
$t = $t.Replace('image: "#{img}/valse-img-020.jpg"', 'image: "photos/newsletter-bg.jpg"')
$t = $t.Replace('image: "/wp-content/uploads/2024/09/Gallery-01.jpg"', 'image: "photos/gallery-01.jpg"')
$t = $t.Replace('Rails.root.join("public/wp-content/uploads/2024/08/Blog-', 'Rails.root.join("app/assets/images/blog/Cover-')
$t = $t.Replace('Rails.root.join("public/wp-content/uploads/2024/08/Testimonials-', 'Rails.root.join("app/assets/images/photos/Student-')
[IO.File]::WriteAllText($p, $t, [Text.UTF8Encoding]::new($false))
Write-Output 'seeds.rb updated'
rg -n 'wp-content|Rails.root.join' $p | ForEach-Object { $_ }