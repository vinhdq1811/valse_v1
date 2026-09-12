puts "Products: #{Product.count}"
puts "Plans:    #{Plan.count}"
Product.ordered.each { |p| puts "#{p.category.to_s.ljust(7)} | #{p.slug.ljust(32)} | #{p.price.to_s.rjust(12)} | #{p.image}" }
Plan.ordered.each { |p| puts "PLAN #{p.name} | #{p.duration} | #{p.price} | features=#{p.features.size}" }
