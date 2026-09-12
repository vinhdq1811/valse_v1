class Product < ApplicationRecord
  enum :category, { course: 0, sheet: 1, piano: 2 }, prefix: true

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :ordered, -> { order(position: :asc, id: :asc) }

  def to_param
    slug
  end
end
