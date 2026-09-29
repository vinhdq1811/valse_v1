module ApplicationHelper
  def format_vnd(amount)
    return "Liên hệ" if amount.nil?

    "#{number_with_delimiter(amount, delimiter: '.')}₫"
  end

  def page_title(default = "Valse Music School")
    @page_title.present? ? "#{@page_title} — Valse" : default
  end

  # Permalink bài viết: /:year/:month/:day/:slug
  def post_path(post, options = {})
    dated_post_path({ year: post.published_at.year, month: post.published_at.strftime("%m"),
                      day: post.published_at.strftime("%d"), slug: post.slug }.merge(options))
  end

  def post_url(post, options = {})
    dated_post_url({ year: post.published_at.year, month: post.published_at.strftime("%m"),
                     day: post.published_at.strftime("%d"), slug: post.slug }.merge(options))
  end
end
