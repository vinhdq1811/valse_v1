class SessionsController < ApplicationController
  layout "theme"

  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Bạn đã thao tác quá nhanh. Vui lòng thử lại sau." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Đăng nhập thành công. Chào mừng bạn trở lại!"
    else
      redirect_to new_session_path, alert: "Email hoặc mật khẩu không đúng. Vui lòng thử lại."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
