class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:category, :author).order(published_at: :desc, id: :desc)
  end

  def show
  end

  def new
    @post = Post.new(published_at: Time.current)
  end

  def create
    @post = Post.new(post_params)
    @post.author = Current.user
    if @post.save
      redirect_to admin_post_path(@post), notice: "Bài viết đã được tạo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @post.featured_image.purge if params[:post][:remove_featured_image] == "1"
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "Bài viết đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "Bài viết đã được xóa.", status: :see_other
  end

  private

    def set_post
      @post = Post.find_by(slug: params[:id]) || Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :slug, :excerpt, :status, :published_at, :category_id,
                                   :featured_image, tag_ids: []).except(:remove_featured_image)
    end
end
