class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.string :from
      t.integer :user_id

      t.timestamps
    end
  end
end
