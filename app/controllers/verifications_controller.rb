class VerificationsController < ApplicationController

  before_filter :get_user
 
  def create
    
    @message = Message.create(:body=>params["Body"].downcase, :image=>params["MediaUrl"])

    # @message.body = params["Body"].downcase
    @from_phone = params["Phone"]

    # Instantiate a Twilio client
    @client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    
    # New user verification
    if @user && @user.verified==nil 
      if @message.body == "yes" 
        @user.update_attribute(:verified, true)
        @client.account.sms.messages.create(
            from: TWILIO_CONFIG['from'],
            to: @user.phone,
            body: "Thanks! You're all set. Now you can send me a barcode or UPC number to see if it's WIC approved."
          )
      else
        @client.account.sms.messages.create(
          from: TWILIO_CONFIG['from'],
          to: @user.phone,
          body: "Sorry, that is not a valid response. Please say 'yes' to verify your account."
        )
      end
    # Receiving any message from verified user    
    elsif @user && @user.verified
      @message.get_upc
      if @message.upc
        print "upc is: " + @message.upc    
      elsif @message.item_requested
        print "item is: " + @message.item_requested    
      end
      

    end


    head :ok
  end
 
  private
  def get_user
    unless @user = User.find_by_phone(params['From'])
      head :not_found
    end
  end

end
