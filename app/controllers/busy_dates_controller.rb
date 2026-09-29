class BusyDatesController < ApplicationController
  layout "theme"

  before_action :require_teacher_or_admin

  def create
    @busy_date = Current.user.busy_dates.new(date: params[:date])
    if @busy_date.save
      redirect_to availabilities_path, notice: "Đã đánh dấu ngày nghỉ."
    else
      redirect_to availabilities_path, alert: @busy_date.errors.full_messages.to_sentence
    end
  end

  def destroy
    @busy_date = Current.user.busy_dates.find(params[:id])
    @busy_date.destroy
    redirect_to availabilities_path, notice: "Đã bỏ đánh dấu ngày nghỉ.", status: :see_other
  end
end
