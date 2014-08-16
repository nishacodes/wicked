class VerificationsController < ApplicationController

  before_filter :get_user
 
  def create
    @user.update_attribute(:verified, true)
    # You could send another message acknowledging the verificaton
  
    # Instantiate a Twilio client
    @client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    @client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: @user.phone,
        body: "You are verified!"
      )
    head :ok
  end

 
  private
  def get_user
    unless @user = User.find_by_phone(params['From'])
      head :not_found
    end
  end

end
