class Category < ApplicationRecord
  include Sluggable

  has_many :posts, dependent: :restrict_with_error

  validates :name, presence: true
end
