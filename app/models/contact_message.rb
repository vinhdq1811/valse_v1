class ContactMessage < ApplicationRecord
  validates :name, :email, :phone, :title, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
