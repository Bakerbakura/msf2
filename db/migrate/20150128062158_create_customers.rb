class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers, id: false do |t|
      t.primary_key :CustID
      t.string  :Name,            limit: 30,  null: false
      t.string  :Email,           limit: 30,  null: false
      t.string  :Gender,          limit: 1,   null: false
      t.string  :password_digest, limit: 60,  null: false
      t.float   :ShoeSize
      t.float   :ShoeSizeError
      t.integer :ShoeCount,                   null: false, default: 0

      t.timestamps
    end
  end
end
