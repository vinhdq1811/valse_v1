map = {
  "/wp-content/uploads/2024/08/valse-img-01.jpg"  => "photos/about-01.jpg",
  "/wp-content/uploads/2024/08/valse-img-02.jpg"  => "photos/about-02.jpg",
  "/wp-content/uploads/2024/08/valse-img-03.jpg"  => "photos/about-03.jpg",
  "/wp-content/uploads/2024/08/valse-img-05.jpg"  => "photos/about-04.jpg",
  "/wp-content/uploads/2024/08/valse-img-012.jpg" => "photos/team-01.jpg",
  "/wp-content/uploads/2024/08/valse-img-013.jpg" => "photos/team-02.jpg",
  "/wp-content/uploads/2024/08/valse-img-014.jpg" => "photos/team-03.jpg",
  "/wp-content/uploads/2024/08/valse-img-015.jpg" => "photos/team-04.jpg",
  "/wp-content/uploads/2024/09/valse-img-016.jpg" => "photos/studio-01.jpg",
  "/wp-content/uploads/2024/10/valse-img-017.jpg" => "photos/studio-02.jpg",
  "/wp-content/uploads/2024/10/valse-img-018.jpg" => "photos/studio-03.jpg",
  "/wp-content/uploads/2024/08/valse-img-020.jpg" => "photos/newsletter-bg.jpg",
  "/wp-content/uploads/2024/09/Gallery-01.jpg"    => "photos/gallery-01.jpg"
}
count = 0
Product.where.not(image: nil).find_each do |p|
  next if p.image.blank? || !p.image.start_with?("/wp-content/")

  new_path = map[p.image]
  if new_path
    p.update_columns(image: new_path)
    count += 1
  else
    puts "KHONG MAP: #{p.id} #{p.image}"
  end
end
puts "Da cap nhat #{count} Product.image"
