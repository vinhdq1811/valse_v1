class ProductsController < CoursesController
  SALE_CATEGORIES = %w[sheet piano].freeze

  def index
    @category = params[:category] if SALE_CATEGORIES.include?(params[:category])
    scope = @category ? Product.where(category: @category) : Product.where(category: SALE_CATEGORIES)
    @products = scope.ordered.order(:category)
    @page_title = @category ? CATEGORY_LABELS[@category] : "Sản phẩm"
  end

  def show
    super
    render "courses/show"
  end
end
