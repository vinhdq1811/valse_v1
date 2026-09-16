class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :bookings, dependent: :destroy

  validates :lessons_per_week, :total_lessons,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user_id, uniqueness: { scope: :plan_id, conditions: -> { where(active: true) } }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:id) }

  def booked_count
    bookings.where(status: :booked).count
  end

  def weekly_booked_count(time = Time.current)
    week_start = time.in_time_zone.beginning_of_week
    week_end = week_start + 1.week
    bookings.where(status: :booked)
            .joins(:lesson)
            .where(lessons: { starts_at: week_start...week_end })
            .count
  end

  def remaining_total
    [total_lessons - booked_count, 0].max
  end

  def remaining_this_week(time = Time.current)
    [lessons_per_week - weekly_booked_count(time), 0].max
  end
end
