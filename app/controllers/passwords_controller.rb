class PasswordsController < ApplicationController
  layout "theme"

  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Bạn đã thao tác quá nhanh. Vui lòng thử lại sau." }

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Nếu email tồn tại trong hệ thống, hướng dẫn đặt lại mật khẩu đã được gửi đến bạn."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to new_session_path, notice: "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại."
    else
      redirect_to edit_password_path(params[:token]), alert: "Mật khẩu xác nhận không khớp hoặc không đạt độ dài tối thiểu."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn."
    end
end
