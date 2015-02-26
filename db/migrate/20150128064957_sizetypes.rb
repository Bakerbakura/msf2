class CreateSizetypes < ActiveRecord::Migration
  def change
    create_table :sizetypes, {id: false, :primary_key => :SizeType} do |t|
      t.string :SizeType, limit: 20, null: false
      t.float :ToMondo1,          null: false
      t.float :ToMondo0,          null: false
      t.float :SizeTypeInterval,  null: false
      t.float :MinSize,           null: false
      t.float :MaxSize,           null: false
    end
    add_index :sizetypes, :SizeType, unique: true
  end
end
