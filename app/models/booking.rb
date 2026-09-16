class Booking < ApplicationRecord
  belongs_to :lesson
  belongs_to :student, class_name: "User"
  belongs_to :enrollment

  enum :status, { booked: 0, cancelled: 1 }

  validate :lesson_must_be_open, on: :create
  validate :lesson_must_not_be_full, on: :create
  validate :student_must_not_double_book, on: :create
  validate :enrollment_weekly_limit, on: :create
  validate :enrollment_total_limit, on: :create
  validates :student_id, uniqueness: { scope: :lesson_id, conditions: -> { where(status: :booked) } }

  scope :upcoming, -> { where(status: :booked).joins(:lesson).where(lessons: { starts_at: Time.current.. }) }
  scope :past, -> { where(status: :booked).joins(:lesson).where(lessons: { starts_at: ...Time.current }) }

  def cancel!
    update!(status: :cancelled)
  end

  private

    def lesson_must_be_open
      return if lesson.blank?

      errors.add(:lesson, "đã bị hủy hoặc đã diễn ra") unless lesson.scheduled? && lesson.starts_at > Time.current
    end

    def lesson_must_not_be_full
      return if lesson.blank?

      return if lesson.bookings.where(status: :booked).where.not(student_id: student_id).count < lesson.max_students

      errors.add(:lesson, "đã đủ sĩ số")
    end

    def student_must_not_double_book
      return if student_id.blank? || lesson.blank?

      overlap = Booking.joins(:lesson)
                       .where(bookings: { student_id: student_id, status: :booked },
                              lessons: { status: :scheduled })
                       .where("lessons.starts_at < :ends AND lessons.ends_at > :starts",
                              ends: lesson.ends_at, starts: lesson.starts_at)
                       .where.not(lesson_id: lesson_id)
      errors.add(:lesson, "trùng với buổi học khác của bạn") if overlap.exists?
    end

    def enrollment_weekly_limit
      return if enrollment.blank? || lesson.blank?

      return unless enrollment.lessons_per_week <= enrollment.weekly_booked_count(lesson.starts_at)

      errors.add(:enrollment, "đã đạt giới hạn #{enrollment.lessons_per_week} buổi/tuần")
    end

    def enrollment_total_limit
      return if enrollment.blank?

      return unless enrollment.total_lessons <= enrollment.booked_count

      errors.add(:enrollment, "đã dùng hết #{enrollment.total_lessons} buổi của khóa")
    end
end
