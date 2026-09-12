class PostsController < ApplicationController
  layout "musicali"
  allow_unauthenticated_access only: [:index, :show]

  def index
    @posts = Post.published.latest.includes(:category, :author, featured_image_attachment: :blob)
    @page_title = "Blog"
  end

  def show
    @post = Post.published.find_by!(
      slug: params[:slug],
      published_at: Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i).all_day
    )
    @related = @post.related_posts.includes(:category, :author, featured_image_attachment: :blob)
    @page_title = @post.title
  end
end
