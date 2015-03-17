class CreateTempCustomers < ActiveRecord::Migration
  def change
    create_table :temp_customers, id: false do |t|
      t.primary_key :tCustID
      t.string :Gender, 						limit: 1,		null: false
      t.string :preferredSizeType,	limit: 20,	null: false
      t.float :ShoeSize
      t.float :ShoeSizeError

      t.timestamps
    end
  end
end
