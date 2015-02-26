class CreateAffectedShoes < ActiveRecord::Migration
  def change
    create_table :affected_shoes do |t|
      t.integer :ShoeID,  limit: 8
      t.integer :OwnerID, limit: 8
      t.integer :T2RS_ID, limit: 8
      t.float :RealSize
      t.float :ShoeSize
    end
    add_index :affected_shoes, :T2RS_ID
  end
end
