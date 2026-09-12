class Post < ApplicationRecord
  include Sluggable

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_rich_text :body
  has_one_attached :featured_image do |attachable|
    attachable.variant :thumb, resize_to_fill: [300, 200]
    attachable.variant :card, resize_to_fill: [800, 533]
    attachable.variant :medium, resize_to_fill: [768, 512]
    attachable.variant :large, resize_to_fill: [1024, 683]
  end

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :excerpt, length: { maximum: 500 }

  scope :published, -> { where(status: :published).where(published_at: ..Time.current) }
  scope :latest, -> { order(published_at: :desc, id: :desc) }
  scope :same_category, ->(post) { where(category_id: post.category_id).where.not(id: post.id) }

  def published?
    super && published_at <= Time.current
  end

  def related_posts(limit = 3)
    self.class.published.latest.same_category(self).limit(limit)
  end

  def display_date
    published_at&.strftime("%B %-d, %Y")
  end

  def excerpt_or_body_preview
    return excerpt if excerpt.present?

    body.to_plain_text.truncate(160, separator: " ")
  end
end
