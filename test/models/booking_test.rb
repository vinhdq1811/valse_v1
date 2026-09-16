require "test_helper"

class BookingTest < ActiveSupport::TestCase
  setup do
    @teacher = users(:teacher)
    @teacher2 = users(:teacher_two)
    @student = users(:two)
    @student2 = users(:student_two)
    @plan = plans(:one)
    @enrollment = Enrollment.create!(user: @student, plan: @plan, lessons_per_week: 2, total_lessons: 4)
    @slot = Availability.create!(user: @teacher, weekday: 1,
                                 start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    @monday = Time.zone.today.next_occurring(:monday)
    @lesson = Lesson.create!(teacher: @teacher, availability: @slot, max_students: 1,
                             starts_at: @slot.slot_starts_at(@monday), ends_at: @slot.slot_ends_at(@monday))
  end

  test "đặt buổi học hợp lệ" do
    booking = Booking.new(lesson: @lesson, student: @student, enrollment: @enrollment)
    assert booking.valid?
  end

  test "không đặt được buổi đã đủ sĩ số" do
    Booking.create!(lesson: @lesson, student: @student2, enrollment: @enrollment)
    booking = Booking.new(lesson: @lesson, student: @student, enrollment: @enrollment)
    assert_not booking.valid?
    assert booking.errors[:lesson].any?
  end

  test "không đặt trùng buổi học của chính mình" do
    Booking.create!(lesson: @lesson, student: @student, enrollment: @enrollment)
    duplicate = Booking.new(lesson: @lesson, student: @student, enrollment: @enrollment)
    assert_not duplicate.valid?
  end

  test "không đặt được hai buổi trùng giờ" do
    slot2 = Availability.create!(user: @teacher2, weekday: 1,
                                 start_time: Time.parse("08:30"), end_time: Time.parse("09:30"))
    lesson2 = Lesson.create!(teacher: @teacher2, availability: slot2, max_students: 1,
                             starts_at: slot2.slot_starts_at(@monday), ends_at: slot2.slot_ends_at(@monday))
    Booking.create!(lesson: @lesson, student: @student, enrollment: @enrollment)

    booking = Booking.new(lesson: lesson2, student: @student, enrollment: @enrollment)
    assert_not booking.valid?
    assert booking.errors[:lesson].any?
  end

  test "không vượt quá số buổi tối đa mỗi tuần" do
    @enrollment.update!(lessons_per_week: 2)
    @lesson.update!(max_students: 5)
    slot_wed = Availability.create!(user: @teacher, weekday: 3,
                                    start_time: Time.parse("09:00"), end_time: Time.parse("10:00"))
    lesson_wed = Lesson.create!(teacher: @teacher, availability: slot_wed, max_students: 5,
                                starts_at: slot_wed.slot_starts_at(@monday + 2),
                                ends_at: slot_wed.slot_ends_at(@monday + 2))
    slot_fri = Availability.create!(user: @teacher, weekday: 5,
                                    start_time: Time.parse("09:00"), end_time: Time.parse("10:00"))
    lesson_fri = Lesson.create!(teacher: @teacher, availability: slot_fri, max_students: 5,
                                starts_at: slot_fri.slot_starts_at(@monday + 4),
                                ends_at: slot_fri.slot_ends_at(@monday + 4))

    Booking.create!(lesson: @lesson, student: @student, enrollment: @enrollment)
    Booking.create!(lesson: lesson_wed, student: @student, enrollment: @enrollment)

    booking = Booking.new(lesson: lesson_fri, student: @student, enrollment: @enrollment)
    assert_not booking.valid?
    assert_includes booking.errors[:enrollment].join, "buổi/tuần"
  end

  test "không vượt quá tổng số buổi của khóa" do
    @enrollment.update!(total_lessons: 1)
    Booking.create!(lesson: @lesson, student: @student, enrollment: @enrollment)

    lesson_next_week = Lesson.create!(teacher: @teacher, availability: @slot, max_students: 5,
                                      starts_at: @slot.slot_starts_at(@monday + 7),
                                      ends_at: @slot.slot_ends_at(@monday + 7))
    booking = Booking.new(lesson: lesson_next_week, student: @student, enrollment: @enrollment)
    assert_not booking.valid?
    assert_includes booking.errors[:enrollment].join, "buổi của khóa"
  end

  test "không đặt được buổi đã qua" do
    past_lesson = Lesson.create!(teacher: @teacher, max_students: 1,
                                 starts_at: 1.hour.ago, ends_at: 30.minutes.ago)
    booking = Booking.new(lesson: past_lesson, student: @student, enrollment: @enrollment)
    assert_not booking.valid?
  end

  test "hủy buổi sẽ mở lại chỗ trống" do
    first = Booking.create!(lesson: @lesson, student: @student, enrollment: @enrollment)
    assert Booking.new(lesson: @lesson, student: @student2, enrollment: @enrollment).invalid?

    first.cancel!
    assert first.cancelled?
    assert Booking.new(lesson: @lesson, student: @student2, enrollment: @enrollment).valid?
  end
end
