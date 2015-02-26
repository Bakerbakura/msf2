class CreateLengthfits < ActiveRecord::Migration
  def change
    create_table :lengthfits, {id: false, :primary_key => :LengthFit} do |t|
      t.string :LengthFit, limit: 20,	null: false
    end
    add_index :lengthfits, :LengthFit, unique: true
  end
end
