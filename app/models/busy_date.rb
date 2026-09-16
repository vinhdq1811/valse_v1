class BusyDate < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user_id }

  scope :ordered_by_date, -> { order(:date) }
end
