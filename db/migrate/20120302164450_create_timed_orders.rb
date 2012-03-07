class CreateTimedOrders < ActiveRecord::Migration
  def change
    create_table :timed_orders do |t|
      t.integer :order_id
      t.datetime :expires_at
    end
    
    add_index :timed_orders, :order_id, :name => 'index_timed_orders_on_order_id'
  end
end
