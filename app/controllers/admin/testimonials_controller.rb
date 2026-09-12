class Admin::TestimonialsController < Admin::BaseController
  before_action :set_testimonial, only: %i[show edit update destroy]

  def index
    @testimonials = Testimonial.ordered
  end

  def show
  end

  def new
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      redirect_to admin_testimonial_path(@testimonial), notice: "Testimonial đã được tạo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @testimonial.avatar.purge if params[:testimonial][:remove_avatar] == "1"
    if @testimonial.update(testimonial_params)
      redirect_to admin_testimonial_path(@testimonial), notice: "Testimonial đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @testimonial.destroy
    redirect_to admin_testimonials_path, notice: "Testimonial đã được xóa.", status: :see_other
  end

  private

    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    def testimonial_params
      params.require(:testimonial).permit(:name, :role, :quote, :rating, :position,
                                          :published, :show_on_home, :avatar)
            .except(:remove_avatar)
    end
end
