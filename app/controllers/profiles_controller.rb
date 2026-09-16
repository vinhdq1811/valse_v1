class ProfilesController < ApplicationController
  layout "musicali"

  ROLE_LABELS = {
    "student" => "Học viên",
    "teacher" => "Giảng viên",
    "admin" => "Quản trị viên",
    "superadmin" => "Quản trị viên"
  }.freeze

  def show
    @user = Current.user
    redirect_to new_session_path unless @user
    @page_title = "Thông tin cá nhân"
  end

  helper_method :role_label

  private

  def role_label
    ROLE_LABELS[@user.role]
  end
end
