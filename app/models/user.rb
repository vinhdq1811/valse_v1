class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :restrict_with_error
  has_many :availabilities, dependent: :destroy
  has_many :busy_dates, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :bookings, foreign_key: :student_id, dependent: :destroy
  has_many :teaching_lessons, class_name: "Lesson", foreign_key: :teacher_id, dependent: :destroy

  enum :role, { student: 0, teacher: 1, admin: 2, superadmin: 3 }, default: :student

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(n) { n.strip }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_blank: true

  scope :staff, -> { where(role: [:admin, :superadmin]) }
  scope :authors, -> { where(role: [:teacher, :admin, :superadmin]) }
  scope :teachers, -> { where(role: [:teacher, :admin, :superadmin]) }
  scope :ordered, -> { order(:name, :id) }

  def admin_or_superadmin?
    admin? || superadmin?
  end

  def teacher_or_admin?
    teacher? || admin_or_superadmin?
  end

  def display_name
    name.presence || email_address.split("@").first
  end

  def initials
    parts = display_name.split(/\s+/)
    return parts.first[0, 2].upcase if parts.size == 1

    [parts.first[0], parts.last[0]].join.upcase
  end
end
