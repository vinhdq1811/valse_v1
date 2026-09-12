class CoursesController < ApplicationController
  layout "musicali"
  allow_unauthenticated_access only: [:index, :show]

  CATEGORY_LABELS = {
    "course" => "Khóa học Piano",
    "sheet" => "Sheet nhạc",
    "piano" => "Đàn piano"
  }.freeze

  def index
    @category = params[:category] if Product.categories.key?(params[:category])
    scope = @category ? Product.where(category: @category) : Product.all
    @products = scope.ordered.order(:category)
    @page_title = @category ? CATEGORY_LABELS[@category] : "Khóa học & Sản phẩm"
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
