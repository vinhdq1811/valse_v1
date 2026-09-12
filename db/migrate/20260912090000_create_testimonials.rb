class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials do |t|
      t.string :name, null: false
      t.string :role
      t.text :quote, null: false
      t.integer :rating
      t.integer :position, default: 0
      t.boolean :published, default: true, null: false
      t.boolean :show_on_home, default: false, null: false

      t.timestamps
    end
  end
end
