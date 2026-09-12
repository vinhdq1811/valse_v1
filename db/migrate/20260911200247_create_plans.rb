class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :tagline
      t.string :duration
      t.string :session_rule
      t.bigint :price, null: false
      t.jsonb :features, default: []
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
