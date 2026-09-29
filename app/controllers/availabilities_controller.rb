class AvailabilitiesController < ApplicationController
  layout "theme"

  before_action :require_teacher_or_admin
  before_action :set_availability, only: %i[edit update destroy]

  def index
    @page_title = "Lịch dạy của tôi"
    @availabilities = Current.user.availabilities.ordered
    @busy_dates = Current.user.busy_dates.ordered_by_date
    @availability = Availability.new
    @default_max_students = Setting.default_max_students
  end

  def new
    @availability = Current.user.availabilities.new
  end

  def create
    @availability = Current.user.availabilities.new(availability_params)
    if @availability.save
      redirect_to availabilities_path, notice: "Đã thêm khung giờ dạy."
    else
      @busy_dates = Current.user.busy_dates.ordered_by_date
      @default_max_students = Setting.default_max_students
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @availability.update(availability_params)
      redirect_to availabilities_path, notice: "Đã cập nhật khung giờ dạy."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @availability.destroy
    redirect_to availabilities_path, notice: "Đã xóa khung giờ dạy.", status: :see_other
  end

  private

    def set_availability
      @availability = Current.user.availabilities.find(params[:id])
    end

    def availability_params
      params.require(:availability).permit(:weekday, :start_time, :end_time, :max_students)
    end
end
