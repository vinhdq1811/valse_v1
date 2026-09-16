require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  setup do
    @teacher = users(:teacher)
  end

  test "khung giờ hợp lệ" do
    slot = Availability.new(user: @teacher, weekday: 1,
                            start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    assert slot.valid?
    assert_nil slot.max_students
    assert_equal 1, slot.effective_max_students
  end

  test "từ chối khung giờ chồng lấn cùng ngày trong tuần" do
    Availability.create!(user: @teacher, weekday: 1,
                         start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    slot = Availability.new(user: @teacher, weekday: 1,
                            start_time: Time.parse("08:30"), end_time: Time.parse("09:30"))
    assert_not slot.valid?
    assert slot.errors[:start_time].present?
  end

  test "cho phép cùng giờ nhưng khác ngày trong tuần" do
    Availability.create!(user: @teacher, weekday: 1,
                         start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    slot = Availability.new(user: @teacher, weekday: 3,
                            start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    assert slot.valid?
  end

  test "từ chối giờ kết thúc trước hoặc bằng giờ bắt đầu" do
    slot = Availability.new(user: @teacher, weekday: 2,
                            start_time: Time.parse("10:00"), end_time: Time.parse("10:00"))
    assert_not slot.valid?
    assert slot.errors[:end_time].present?
  end

  test "sĩ số tùy chỉnh phải lớn hơn 0" do
    slot = Availability.new(user: @teacher, weekday: 2,
                            start_time: Time.parse("10:00"), end_time: Time.parse("11:00"),
                            max_students: 0)
    assert_not slot.valid?
  end

  test "weekday phải nằm trong 0..6" do
    slot = Availability.new(user: @teacher, weekday: 7,
                            start_time: Time.parse("10:00"), end_time: Time.parse("11:00"))
    assert_not slot.valid?
  end

  test "slot_starts_at giữ đúng giờ đã nhập theo giờ Việt Nam" do
    slot = Availability.new(user: @teacher, weekday: 1,
                            start_time: Time.parse("08:00"), end_time: Time.parse("09:30"))
    date = Time.zone.today.next_occurring(:monday)
    assert_equal Time.zone.local(date.year, date.month, date.day, 8, 0), slot.slot_starts_at(date)
    assert_equal Time.zone.local(date.year, date.month, date.day, 9, 30), slot.slot_ends_at(date)
    assert_equal "08:00 – 09:30", slot.time_range_label
  end
end
