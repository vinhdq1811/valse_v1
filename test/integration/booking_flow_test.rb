require "test_helper"

class BookingFlowTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = users(:teacher)
    @teacher2 = users(:teacher_two)
    @admin = users(:admin)
    @student = users(:two)
    @plan = plans(:one)
    @enrollment = Enrollment.create!(user: @student, plan: @plan, lessons_per_week: 2, total_lessons: 4)
    @slot = Availability.create!(user: @teacher, weekday: 1,
                                 start_time: Time.parse("08:00"), end_time: Time.parse("09:00"))
    @monday = Time.zone.today.next_occurring(:monday)
  end

  test "student xem được lịch tuần của giáo viên" do
    sign_in_as @student
    get teacher_path(@teacher, week: @monday)
    assert_response :success
    assert_match "Còn 1/1 chỗ", @response.body
  end

  test "student đặt và hủy buổi học" do
    sign_in_as @student
    assert_difference -> { Lesson.count }, 1 do
      assert_difference -> { Booking.where(status: :booked).count }, 1 do
        post bookings_path, params: {
          availability_id: @slot.id,
          date: @monday.iso8601,
          enrollment_id: @enrollment.id
        }
      end
    end
    assert_redirected_to teacher_path(@teacher)

    booking = Booking.where(student: @student).last
    assert_equal "booked", booking.status

    delete booking_path(booking)
    assert_redirected_to bookings_path
    assert_equal "cancelled", booking.reload.status
  end

  test "student bị chặn khi vượt giới hạn buổi mỗi tuần" do
    slot_wed = Availability.create!(user: @teacher2, weekday: 3,
                                    start_time: Time.parse("09:00"), end_time: Time.parse("10:00"))
    slot_fri = Availability.create!(user: @teacher2, weekday: 5,
                                    start_time: Time.parse("09:00"), end_time: Time.parse("10:00"))
    lesson_a = Lesson.create!(teacher: @teacher, availability: @slot, max_students: 5,
                              starts_at: @slot.slot_starts_at(@monday), ends_at: @slot.slot_ends_at(@monday))
    lesson_b = Lesson.create!(teacher: @teacher2, availability: slot_wed, max_students: 5,
                              starts_at: slot_wed.slot_starts_at(@monday + 2),
                              ends_at: slot_wed.slot_ends_at(@monday + 2))
    Booking.create!(lesson: lesson_a, student: @student, enrollment: @enrollment)
    Booking.create!(lesson: lesson_b, student: @student, enrollment: @enrollment)

    sign_in_as @student
    assert_no_difference -> { Booking.where(status: :booked).count } do
      post bookings_path, params: {
        availability_id: slot_fri.id,
        date: (@monday + 4).iso8601,
        enrollment_id: @enrollment.id
      }
    end
    assert_redirected_to teacher_path(@teacher2)
    follow_redirect!
    assert_match "buổi/tuần", @response.body
  end

  test "student không vào được trang cài đặt lịch dạy" do
    sign_in_as @student
    get availabilities_path
    assert_redirected_to root_path
  end

  test "teacher chỉ sửa được khung giờ của chính mình" do
    sign_in_as @teacher2
    patch availability_path(@slot), params: {
      availability: { weekday: 2, start_time: "10:00", end_time: "11:00" }
    }
    assert_response :not_found
    assert_equal 1, @slot.reload.weekday
  end

  test "teacher quản lý khung giờ và ngày nghỉ của mình" do
    sign_in_as @teacher
    get availabilities_path
    assert_response :success

    assert_difference -> { Availability.count }, 1 do
      post availabilities_path, params: {
        availability: { weekday: 5, start_time: "09:00", end_time: "10:00", max_students: "" }
      }
    end
    assert_redirected_to availabilities_path

    assert_difference -> { BusyDate.count }, 1 do
      post busy_dates_path, params: { date: (@monday + 4).iso8601 }
    end
    assert_redirected_to availabilities_path
  end

  test "admin quy định sĩ số mặc định" do
    sign_in_as @admin
    get edit_admin_settings_path
    assert_response :success

    patch admin_settings_path, params: { default_max_students: 5 }
    assert_redirected_to edit_admin_settings_path
    assert_equal 5, Setting.default_max_students
  end

  test "admin xem được danh sách buổi học" do
    sign_in_as @admin
    Lesson.create!(teacher: @teacher, availability: @slot, max_students: 1,
                   starts_at: @slot.slot_starts_at(@monday), ends_at: @slot.slot_ends_at(@monday))
    get admin_lessons_path
    assert_response :success
    assert_match "Giáo viên Một", @response.body
  end
end
