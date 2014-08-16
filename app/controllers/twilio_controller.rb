require 'twilio-ruby'

 
class TwilioController < ApplicationController
  include Webhookable
 
  after_filter :set_header
  
  skip_before_action :verify_authenticity_token
 
  sender = params[:From]
  friends = {
    "+14154257945" => "Curious George",
  }
  name = friends[sender] || "Mobile Monkey"
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Hello, #{name}. Thanks for the message."
  end
  twiml.text
end