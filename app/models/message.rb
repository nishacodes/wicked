class Message < ActiveRecord::Base
  attr_accessible :body, :from, :user_id, :image, :upc, :item_requested

  def get_upc
    upc_type = /^[0-9]+/
    if (self.body =~ upc_type) 
      self.upc = self.body
    else
      self.item_requested = self.body
    end
  end

end
