require "test_helper"

class AdminTestimonialsTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @testimonial = testimonials(:published_one)
  end

  test "khách chưa đăng nhập bị chuyển tới trang đăng nhập" do
    get admin_testimonials_path
    assert_redirected_to new_session_path
  end

  test "member thường không vào được admin" do
    sign_in_as(users(:one))
    get admin_testimonials_path
    assert_redirected_to root_path
  end

  test "admin xem danh sách testimonials" do
    sign_in_as(@admin)
    get admin_testimonials_path
    assert_response :success
    assert_match @testimonial.name, response.body
  end

  test "admin tạo testimonial mới" do
    sign_in_as(@admin)
    assert_difference "Testimonial.count", 1 do
      post admin_testimonials_path, params: {
        testimonial: {
          name: "Minh Anh",
          role: "Doanh nhân",
          quote: "Khóa học rất hay, giảng viên nhiệt tình!",
          rating: "",
          position: 6,
          published: "1"
        }
      }
    end
    assert_redirected_to admin_testimonial_path(Testimonial.last)
  end

  test "admin cập nhật testimonial" do
    sign_in_as(@admin)
    patch admin_testimonial_path(@testimonial), params: {
      testimonial: { name: "Sarah M Updated", rating: "4" }
    }
    assert_redirected_to admin_testimonial_path(@testimonial)
    @testimonial.reload
    assert_equal "Sarah M Updated", @testimonial.name
    assert_equal 4, @testimonial.rating
  end

  test "admin xóa testimonial" do
    sign_in_as(@admin)
    assert_difference "Testimonial.count", -1 do
      delete admin_testimonial_path(@testimonial)
    end
    assert_redirected_to admin_testimonials_path
  end

  test "trang public /testimonials chỉ hiển thị bản published" do
    get testimonials_path
    assert_response :success
    assert_match @testimonial.quote, response.body
    assert_no_match testimonials(:hidden_one).quote, response.body
  end
end
