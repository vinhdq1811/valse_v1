class TeachersController < ApplicationController
  layout "musicali"

  def index
    @page_title = "Đặt lịch học"
    @teachers = User.teachers.ordered
  end

  def show
    @teacher = User.teachers.find(params[:id])
    @page_title = "Lịch dạy #{@teacher.display_name}"
    @week_start = parsed_week
    @days = (@week_start...(@week_start + 7)).to_a

    @busy_dates = @teacher.busy_dates.where(date: @week_start..(@week_start + 6)).index_by(&:date)
    @availabilities = @teacher.availabilities.ordered
    lessons = @teacher.teaching_lessons.scheduled
                      .includes(bookings: :student)
                      .in_range(slot_range)
    @lessons_by_slot = lessons.index_by { |lesson| [lesson.starts_at.to_date, lesson.availability_id] }

    @my_enrollments = Current.user.enrollments.active
    @my_bookings_by_lesson = Booking.where(student: Current.user, status: :booked).index_by(&:lesson_id)
  end

  private

    def parsed_week
      week = Date.parse(params[:week].to_s)
      week.beginning_of_week
    rescue ArgumentError
      Time.zone.today.beginning_of_week
    end

    def slot_range
      first = @availabilities.map(&:start_time).min
      last = @availabilities.map(&:end_time).max
      return (@week_start.beginning_of_day..(@week_start + 7).end_of_day) if first.nil? || last.nil?

      lower = Time.zone.local(@week_start.year, @week_start.month, @week_start.day, first.hour, first.min)
      upper = Time.zone.local((@week_start + 6).year, (@week_start + 6).month, (@week_start + 6).day, last.hour, last.min)
      (lower.beginning_of_minute..upper.end_of_minute)
    end
end
