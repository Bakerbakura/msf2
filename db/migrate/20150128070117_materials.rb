class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials, {id: false, :primary_key => :Material} do |t|
      t.string :Material, limit: 20, null: false
    end
    add_index :materials, :Material, unique: true
  end
end
