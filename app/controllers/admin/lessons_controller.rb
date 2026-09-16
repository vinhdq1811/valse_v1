class Admin::LessonsController < Admin::BaseController
  before_action :set_lesson, only: %i[destroy]

  def index
    @lessons = Lesson.ordered.includes(:teacher, bookings: :student)
    @lessons = @lessons.where(status: params[:status]) if params[:status].in?(Lesson.statuses.keys)
  end

  def cancel
    @lesson = Lesson.find(params[:id])
    @lesson.cancel!
    redirect_to admin_lessons_path, notice: "Đã hủy buổi học và các đăng ký liên quan.", status: :see_other
  end

  def destroy
    @lesson.destroy
    redirect_to admin_lessons_path, notice: "Đã xóa buổi học.", status: :see_other
  end

  private

    def set_lesson
      @lesson = Lesson.find(params[:id])
    end
end
