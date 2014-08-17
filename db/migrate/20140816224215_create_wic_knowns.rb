class CreateWicKnowns < ActiveRecord::Migration
  def create
    create_table :messages do |t|
      t.integer :upc
      t.string :state
      
    end
  end
end
