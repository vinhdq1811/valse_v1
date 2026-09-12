# Renders the new data-driven views in isolation (no HTTP, no pending-migration
# middleware) and asserts expected content. Immune to concurrent migrations.
#   docker compose exec web bin/rails runner scripts/render_check.rb

def check(label, ok)
  puts "#{ok ? "OK  " : "FAIL"} #{label}"
  exit 1 unless ok
end

courses_renderer = CoursesController.renderer.new(
  http_host: "127.0.0.1:3000",
  https: false
)

# ---- /courses ----
html = courses_renderer.render(:index, layout: "musicali", assigns: {
  products: Product.ordered.order(:category),
  page_title: "Khóa học & Sản phẩm"
})
check("/courses title", html.include?("Khóa học &amp; Sản phẩm") || html.include?("Khóa học & Sản phẩm"))
check("/courses tab sheet", html.include?("courses?category=sheet"))
check("/courses tab piano", html.include?("courses?category=piano"))
check("/courses card đệm hát", html.include?("piano-dem-hat"))
check("/courses card yamaha", html.include?("piano-dien-yamaha-p-145"))
check("/courses giá từ 5tr", html.include?("Từ <strong>5.000.000₫</strong>"))
check("/courses css", html.include?("valse-pages.css"))
check("/courses nav mới", html.include?("/courses?category=sheet\">Sheet nhạc</a>"))

# ---- /courses?category=sheet ----
html = courses_renderer.render(:index, layout: "musicali", assigns: {
  category: "sheet",
  products: Product.where(category: "sheet").ordered,
  page_title: "Sheet nhạc"
})
check("/courses?sheet title", html.include?("Sheet nhạc"))
check("/courses?sheet chỉ có sheet", html.include?("canon-in-d-pachelbel") && !html.include?("piano-co-ban"))
check("/courses?sheet giá", html.include?("80.000₫"))

# ---- /courses/piano-co-ban (khóa học) ----
product = Product.find_by!(slug: "piano-co-ban")
html = courses_renderer.render(:show, layout: "musicali", assigns: {
  product: product,
  plans: Plan.ordered,
  related: Product.where(category: "course").where.not(id: product.id).ordered.limit(3),
  page_title: product.name
})
check("show course title", html.include?("Khóa học Piano Cơ bản"))
check("show course 2 gói", html.include?("Chọn gói học phù hợp"))
check("show gói Linh hoạt", html.include?("Gói Linh hoạt"))
check("show gói 30 buổi", html.include?("Gói 30 buổi"))
check("show 5.000.000₫", html.include?("5.000.000₫"))
check("show badge phổ biến", html.include?("Phổ biến nhất"))
check("show đăng ký", html.include?("Đăng ký ngay"))
check("show quy tắc 3 buổi/tuần", html.include?("Tối đa 3 buổi mỗi tuần"))
check("show duration 6 tháng", html.include?("6 tháng"))

# ---- /courses/piano-dien-yamaha-p-145 (đàn) ----
product = Product.find_by!(slug: "piano-dien-yamaha-p-145")
html = courses_renderer.render(:show, layout: "musicali", assigns: {
  product: product,
  related: Product.where(category: "piano").where.not(id: product.id).ordered.limit(3),
  page_title: product.name
})
check("show piano title", html.include?("Yamaha P-145"))
check("show piano giá", html.include?("18.900.000₫"))
check("show piano CTA mua", html.include?("Liên hệ đặt mua"))
check("show piano không có gói", !html.include?("Chọn gói học phù hợp"))

# ---- /pricing ----
pages_renderer = PagesController.renderer.new(
  http_host: "127.0.0.1:3000",
  https: false
)
html = pages_renderer.render("pricing", layout: "musicali", assigns: { plans: Plan.ordered })
check("pricing title", html.include?("Học phí"))
check("pricing 2 gói", html.include?("Gói Linh hoạt") && html.include?("Gói 30 buổi"))
check("pricing bảng so sánh", html.include?("Hai gói khác nhau ở điểm nào?"))
check("pricing giá", html.include?("5.000.000₫"))
check("pricing FAQ", html.include?("Câu hỏi thường gặp"))

puts "ALL CHECKS PASSED"
