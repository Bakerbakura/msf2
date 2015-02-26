class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles, {id: false, :primary_key => :Style} do |t|
      t.string :Style, limit: 20,	null: false
    end
    add_index :styles, :Style, unique: true
  end
end
