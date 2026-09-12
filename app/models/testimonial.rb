class Testimonial < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 100, 100 ]
  end

  validates :name, presence: true
  validates :quote, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_blank: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, id: :asc) }

  def initials
    name.split.map { |part| part[0] }.join.slice(0, 2).upcase
  end
end
