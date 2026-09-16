class Setting < ApplicationRecord
  DEFAULTS = {
    "default_max_students" => 1
  }.freeze

  validates :key, presence: true, uniqueness: true
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 1 },
                    if: -> { key == "default_max_students" }

  def self.[](key)
    key = key.to_s
    Rails.cache.fetch("setting:#{key}") do
      find_by(key: key)&.value.presence || DEFAULTS.fetch(key).to_s
    end
  end

  def self.[]=(key, value)
    key = key.to_s
    record = find_or_initialize_by(key: key)
    record.value = value.to_s
    record.save!
    Rails.cache.delete("setting:#{key}")
    value
  end

  def self.default_max_students
    self[:default_max_students].to_i
  end

  def self.default_max_students=(value)
    self[:default_max_students] = value
  end
end
