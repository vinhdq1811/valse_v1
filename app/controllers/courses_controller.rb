class CoursesController < ApplicationController
  layout "theme"
  allow_unauthenticated_access only: [:index, :show]

  CATEGORY_LABELS = {
    "course" => "Khóa học Piano",
    "sheet" => "Sheet nhạc",
    "piano" => "Đàn piano cũ"
  }.freeze

  def index
    @products = Product.category_course.ordered
    @page_title = CATEGORY_LABELS["course"]
  end

  def show
    @product = Product.find_by!(slug: params[:slug])
    @plans = Plan.ordered if @product.category_course?
    @related = Product.where(category: @product.category).where.not(id: @product.id).ordered.limit(3)
    @page_title = @product.name
  end

  helper_method :category_label

  private

  def category_label(key)
    CATEGORY_LABELS[key]
  end
end
