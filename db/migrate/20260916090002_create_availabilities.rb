class CreateAvailabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :availabilities do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :weekday, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      # nil = dùng sĩ số mặc định do admin quy định
      t.integer :max_students

      t.timestamps
    end
  end
end
