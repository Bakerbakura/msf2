class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers, id: false do |t|
      t.primary_key :CustID
      t.string :Email,            limit: 30,  null: false
      t.string :Gender,           limit: 1,   null: false
      t.string :password_digest,  limit: 60,  null: false
      t.float :ShoeSize
      t.float :ShoeSizeError
      t.string :preferredSizeType, limit: 20, null: false

      t.timestamps
    end
  end
end
