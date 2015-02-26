class CreateTypetorealsizes < ActiveRecord::Migration
  def change
    create_table :typetorealsizes, id: false do |t|
      t.primary_key :T2RS_ID
      t.string :BrandStyleMaterial, limit: 70,  null: false
      t.float :ToMondo1,                        null: false,  default: 1.0
      t.float :ToMondo0,                        null: false,  default: 0.0
      t.boolean :modified,                      null: false,  default: false
      t.float :Uncertainty,                                   default: 0.0

      t.timestamps
    end
    add_index :typetorealsizes, :BrandStyleMaterial, unique: true
  end
end
