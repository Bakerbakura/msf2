class CreateT2rsEntryInfos < ActiveRecord::Migration
  def change
    create_table :t2rs_entry_infos do |t|
      t.integer :OwnerID, limit: 8
      t.float :PreSize
      t.float :RealSize
      t.float :ShoeSize
    end
  end
end
