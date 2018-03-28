class AddLastJobIdToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :last_task_id, :string, default: 0
  end
end