class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.text :countries
      t.integer :roast_level
      t.string :image
      t.integer :prefecture_id
      t.float :latitude
      t.float :longitude
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
