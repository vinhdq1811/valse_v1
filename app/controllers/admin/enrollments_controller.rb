class Admin::EnrollmentsController < Admin::BaseController
  before_action :set_enrollment, only: %i[edit update destroy]

  def index
    @enrollments = Enrollment.ordered.includes(:user, :plan)
    @booked_counts = Booking.where(status: :booked).group(:enrollment_id).count
  end

  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to admin_enrollments_path, notice: "Đã tạo đăng ký khóa học."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @enrollment.update(enrollment_params)
      redirect_to admin_enrollments_path, notice: "Đã cập nhật đăng ký khóa học."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment.destroy
    redirect_to admin_enrollments_path, notice: "Đã xóa đăng ký khóa học.", status: :see_other
  end

  private

    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    def enrollment_params
      params.require(:enrollment).permit(:user_id, :plan_id, :lessons_per_week, :total_lessons, :active)
    end
end
