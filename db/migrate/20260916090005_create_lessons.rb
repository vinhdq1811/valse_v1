class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :availability
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :max_students, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :lessons, [:teacher_id, :starts_at]
    add_index :lessons, [:availability_id, :starts_at]
    add_foreign_key :lessons, :availabilities
  end
end
