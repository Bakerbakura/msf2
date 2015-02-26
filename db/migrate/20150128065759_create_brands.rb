class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands, {id: false, primary_key: :Brand} do |t|
      t.string :Brand, limit: 30,	null: false
    end
    add_index :brands, :Brand, unique: true
  end
end
