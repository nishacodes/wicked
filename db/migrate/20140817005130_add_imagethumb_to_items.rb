class AddImagethumbToItems < ActiveRecord::Migration
  def change
    add_column :items, :imagethumb, :string
  end
end
