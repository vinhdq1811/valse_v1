class Availability < ApplicationRecord
  belongs_to :user

  WEEKDAY_NAMES = {
    0 => "Chủ nhật",
    1 => "Thứ hai",
    2 => "Thứ ba",
    3 => "Thứ tư",
    4 => "Thứ năm",
    5 => "Thứ sáu",
    6 => "Thứ bảy"
  }.freeze

  validates :weekday, presence: true, inclusion: { in: WEEKDAY_NAMES.keys }
  validates :start_time, :end_time, presence: true
  validates :max_students, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
  validate :end_after_start
  validate :no_overlap

  scope :ordered, -> { order(:weekday, :start_time) }

  def weekday_name
    WEEKDAY_NAMES.fetch(weekday, "")
  end

  def effective_max_students
    max_students || Setting.default_max_students
  end

  def time_range_label
    "#{stored_clock(start_time)} – #{stored_clock(end_time)}"
  end

  def lesson_on(date)
    starts = slot_starts_at(date)
    lessons.scheduled.find_by(starts_at: starts)
  end

  # Cột :time của Rails được đọc về theo timezone ứng dụng (UTC nội bộ),
  # nên giờ trong ngày phải lấy từ phần UTC để ra đúng giờ đã nhập.
  def slot_starts_at(date)
    clock = start_time.utc
    Time.zone.local(date.year, date.month, date.day, clock.hour, clock.min)
  end

  def slot_ends_at(date)
    clock = end_time.utc
    Time.zone.local(date.year, date.month, date.day, clock.hour, clock.min)
  end

  private

    def stored_clock(time)
      clock = time.utc
      format("%02d:%02d", clock.hour, clock.min)
    end

    def end_after_start
      return if start_time.blank? || end_time.blank?

      errors.add(:end_time, "phải sau giờ bắt đầu") if end_time <= start_time
    end

    def no_overlap
      return if user_id.blank? || start_time.blank? || end_time.blank?

      scope = user.availabilities.where(weekday: weekday)
                  .where("start_time < :end AND end_time > :start", end: end_time, start: start_time)
      scope = scope.where.not(id: id) if persisted?
      errors.add(:start_time, "trùng với một khung giờ khác trong tuần") if scope.exists?
    end
end
