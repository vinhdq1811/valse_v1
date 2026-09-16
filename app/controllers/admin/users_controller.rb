class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update]

  def index
    @users = User.ordered
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Đã tạo tài khoản."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = user_params
    attrs = attrs.except(:password) if attrs[:password].blank?
    if update_allowed? && @user.update(attrs)
      redirect_to admin_users_path, notice: "Đã cập nhật tài khoản."
    else
      flash.now[:alert] = "Bạn không có quyền chỉnh sửa tài khoản superadmin." unless update_allowed?
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email_address, :role, :password)
    end

    # Chỉ superadmin được gán/xóa role superadmin hoặc sửa tài khoản superadmin.
    def update_allowed?
      return false if @user.superadmin? && !Current.user.superadmin?
      return false if user_params[:role] == "superadmin" && !Current.user.superadmin?

      true
    end
end
