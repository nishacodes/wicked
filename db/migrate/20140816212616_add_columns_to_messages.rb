class AddColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :upc, :string
    add_column :messages, :item_requested, :string
  end
end
