class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :restrict_with_error

  enum :role, { student: 0, teacher: 1, admin: 2, superadmin: 3 }, default: :student

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(n) { n.strip }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_blank: true

  scope :staff, -> { where(role: [:admin, :superadmin]) }
  scope :authors, -> { where(role: [:teacher, :admin, :superadmin]) }

  def admin_or_superadmin?
    admin? || superadmin?
  end

  def display_name
    name.presence || email_address.split("@").first
  end
end
