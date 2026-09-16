class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :enrollment, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.text :notes

      t.timestamps
    end
    add_index :bookings, [:student_id, :status]
    add_index :bookings, [:enrollment_id, :status]
  end
end
