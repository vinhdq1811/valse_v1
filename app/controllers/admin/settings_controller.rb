class Admin::SettingsController < Admin::BaseController
  def edit
    @page_title = "Cài đặt"
    @default_max_students = Setting.default_max_students
  end

  def update
    value = params[:default_max_students].to_i
    if value >= 1
      Setting.default_max_students = value
      redirect_to edit_admin_settings_path, notice: "Đã lưu cài đặt."
    else
      flash.now[:alert] = "Sĩ số mặc định phải là số nguyên lớn hơn hoặc bằng 1."
      render :edit, status: :unprocessable_entity
    end
  end
end
