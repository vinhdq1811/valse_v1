class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :category, null: false, default: 0
      t.text :summary
      t.text :description
      t.jsonb :highlights, default: []
      t.bigint :price
      t.string :image
      t.integer :position, default: 0

      t.timestamps
    end
    add_index :products, :slug, unique: true
    add_index :products, :category
  end
end
