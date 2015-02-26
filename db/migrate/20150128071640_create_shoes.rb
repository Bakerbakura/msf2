class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes, id: false do |t|
      t.primary_key :ShoeID
      t.integer :OwnerID,     limit: 8,   null: false
      t.integer :T2RS_ID,     limit: 8,   null: false
      t.string :Brand,        limit: 30,  null: false
      t.string :Style,        limit: 20,  null: false
      t.string :Material,     limit: 20,  null: false
      t.string :SizeType,     limit: 20,  null: false
      t.string :LengthFit,    limit: 20,  null: false
      t.float :Size,                      null: false
      t.float :preRealSize
      t.float :RealSize

      t.timestamps
    end
  end
end
