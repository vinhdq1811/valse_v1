class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.integer :lessons_per_week, null: false
      t.integer :total_lessons, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
