class BookingsController < ApplicationController
  layout "musicali"

  def index
    @page_title = "Lịch của tôi"
    @active_enrollments = Current.user.enrollments.active.includes(:plan)
    @upcoming_bookings = Current.user.bookings.upcoming.includes(:enrollment, lesson: :teacher).order("lessons.starts_at")
    @past_bookings = Current.user.bookings.past.includes(:enrollment, lesson: :teacher).order("lessons.starts_at desc")

    if Current.user.teacher_or_admin?
      scope = Current.user.teaching_lessons.where(status: :scheduled).includes(bookings: :student)
      @upcoming_lessons = scope.where(starts_at: Time.current..).ordered
      @past_lessons = scope.where(starts_at: ...Time.current).order(starts_at: :desc)
    end
  end

  def create
    availability = Availability.find(params[:availability_id])
    date = parse_date
    enrollment = Current.user.enrollments.active.find(params[:enrollment_id])

    lesson = Lesson.find_or_open_from_slot(availability, date)
    booking = Booking.new(lesson: lesson, student: Current.user,
                          enrollment: enrollment, notes: params[:notes].presence)

    lesson.with_lock do
      if booking.save
        redirect_to teacher_path(availability.user),
                    notice: "Đã đặt buổi học #{lesson.starts_at.strftime("%H:%M ngày %d/%m/%Y")} với #{availability.user.display_name}."
      else
        redirect_to teacher_path(availability.user), alert: booking.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    booking = Current.user.bookings.find(params[:id])
    booking.cancel!
    redirect_to bookings_path, notice: "Đã hủy buổi học."
  end

  private

    def parse_date
      Date.parse(params[:date].to_s).tap do |date|
        raise ArgumentError if date < Time.zone.today
      end
    rescue ArgumentError
      raise ActiveRecord::RecordNotFound
    end
end
