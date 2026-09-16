class CreateBusyDates < ActiveRecord::Migration[8.1]
  def change
    create_table :busy_dates do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end
    add_index :busy_dates, [:user_id, :date], unique: true
  end
end
