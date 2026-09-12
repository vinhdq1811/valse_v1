class Plan < ApplicationRecord
  scope :ordered, -> { order(position: :asc, id: :asc) }
end
