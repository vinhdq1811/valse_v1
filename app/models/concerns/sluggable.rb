module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_slug
    validates :slug, presence: true, uniqueness: true,
                     format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "chỉ chứa chữ thường, số và dấu gạch ngang" }
  end

  def to_param
    slug
  end

  private

    def normalize_slug
      self.slug = (slug.presence || slug_source).parameterize
      ensure_unique_slug
    end

    def slug_source
      try(:title).presence || try(:name).presence || SecureRandom.hex(4)
    end

    def ensure_unique_slug
      base = slug
      candidate = base
      suffix = 2
      scope = self.class.where.not(id: respond_to?(:id) ? id : nil)
      while scope.exists?(slug: candidate)
        candidate = "#{base}-#{suffix}"
        suffix += 1
      end
      self.slug = candidate
    end
end
