require "test_helper"

class TestimonialTest < ActiveSupport::TestCase
  test "valid với name và quote" do
    assert Testimonial.new(name: "Sarah M", quote: "Khóa học tuyệt vời!").valid?
  end

  test "yêu cầu name và quote" do
    testimonial = Testimonial.new
    refute testimonial.valid?
    assert_not_empty testimonial.errors[:name]
    assert_not_empty testimonial.errors[:quote]
  end

  test "rating phải nằm trong 1..5 hoặc để trống" do
    refute Testimonial.new(name: "A", quote: "B", rating: 0).valid?
    refute Testimonial.new(name: "A", quote: "B", rating: 6).valid?
    assert Testimonial.new(name: "A", quote: "B", rating: 5).valid?
    assert Testimonial.new(name: "A", quote: "B").valid?
  end

  test "scope published chỉ trả về bản đã xuất bản" do
    assert_includes Testimonial.published, testimonials(:published_one)
    assert_not_includes Testimonial.published, testimonials(:hidden_one)
  end

  test "scope ordered sắp theo position" do
    assert_equal [
      testimonials(:published_one).id,
      testimonials(:published_two).id,
      testimonials(:hidden_one).id
    ], Testimonial.ordered.ids
  end

  test "initials lấy chữ cái đầu của tên" do
    assert_equal "SM", testimonials(:published_one).initials
  end
end
