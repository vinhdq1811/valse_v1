class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :availability, optional: true
  has_many :bookings, dependent: :destroy
  has_many :students, through: :bookings, source: :student

  enum :status, { scheduled: 0, cancelled: 1, completed: 2 }

  validates :starts_at, :ends_at, :max_students, presence: true
  validates :max_students, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :end_after_start

  scope :ordered, -> { order(:starts_at) }
  scope :in_range, ->(range) { where(starts_at: range) }

  def booked_count
    bookings.where(status: :booked).count
  end

  def seats_left
    [max_students - booked_count, 0].max
  end

  def full?
    booked_count >= max_students
  end

  def time_range_label
    "#{starts_at.strftime("%H:%M")} – #{ends_at.strftime("%H:%M")}"
  end

  def cancel!
    transaction do
      bookings.where(status: :booked).find_each { |booking| booking.update!(status: :cancelled) }
      update!(status: :cancelled)
    end
  end

  # Tìm buổi học đã mở theo slot, hoặc mở buổi mới (kê thừa sĩ số đã resolve).
  def self.find_or_open_from_slot(availability, date)
    starts_at = availability.slot_starts_at(date)
    ends_at = availability.slot_ends_at(date)
    lesson = scheduled.find_by(availability_id: availability.id, starts_at: starts_at)
    return lesson if lesson

    create!(teacher: availability.user, availability: availability,
            starts_at: starts_at, ends_at: ends_at,
            max_students: availability.effective_max_students)
  end

  private

    def end_after_start
      return if starts_at.blank? || ends_at.blank?

      errors.add(:ends_at, "phải sau giờ bắt đầu") if ends_at <= starts_at
    end
end
