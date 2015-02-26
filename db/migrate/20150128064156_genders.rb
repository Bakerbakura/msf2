class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders, {id: false, :primary_key => :Gender} do |t|
      t.string :Gender, limit: 1, null: false
    end
    add_index :genders, :Gender, unique: true
  end
end
