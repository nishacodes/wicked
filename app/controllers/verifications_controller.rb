class VerificationsController < ApplicationController
  require 'net/http'
  before_filter :get_user
 
  def create
    
    @message = Message.create(:body=>params["Body"].downcase, :image=>params["MediaUrl"])

    # @message.body = params["Body"].downcase
    @phone = params["Phone"]

    # Instantiate a Twilio client
    @client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    
    # New user verification
    if @user && @user.verified==nil 
      @phone = @user.phone
      if @message.body == "yes" 
        @user.update_attribute(:verified, true)
        @response = "Thanks! You're all set. Now you can send me a barcode or UPC number to see if it's WIC approved."
        # @client.account.sms.messages.create(
        #     from: TWILIO_CONFIG['from'],
        #     to: @user.phone,
        #     body: "Thanks! You're all set. Now you can send me a barcode or UPC number to see if it's WIC approved."
        #   )
      else
        @response = "Sorry, that is not a valid response. Please say 'yes' to verify your account."
        # @client.account.sms.messages.create(
        #   from: TWILIO_CONFIG['from'],
        #   to: @user.phone,
        #   body: "Sorry, that is not a valid response. Please say 'yes' to verify your account."
        # )
      end
    
    # Receiving any message from verified user    
    elsif @user && @user.verified
      @phone = @user.phone
      @message.get_upc
      # if it's a upc number, get the info from upc api
      if @message.upc
        puts "upc is: " + @message.upc    
        # 689544080008  
        uri = URI("http://api.simpleupc.com/v1.php?auth=gqA1YvUeSLhWA6h5dvICvzUaYe3Dff8M&method=FetchProductByUPC&upc=#{@message.upc}&returnFormat=json")
        res = Net::HTTP.get_response(uri)
        
        # if there's results, save it in the items database
        if res.body
          item_info = JSON.parse(res.body)["result"]
          @item = Item.create(item_info)
          

          puts "-----"
          puts @item.brand 
          puts @item.category
          # save nutrition info in a hash
          if @item.ProductHasNutritionFacts == true
            nutritionUri = URI("http://api.simpleupc.com/v1.php?auth=gqA1YvUeSLhWA6h5dvICvzUaYe3Dff8M&method=FetchNutritionFactsByUPC&upc=#{@item.upc}")
            nutritionfacts = Net::HTTP.get_response(nutritionUri)
            @item.nutrition = JSON.parse(nutritionfacts.body)["result"]
          end

          # save image to db
          if @item.ProductHasImage == true
            imageUri = URI("http://api.simpleupc.com/v1.php?auth=gqA1YvUeSLhWA6h5dvICvzUaYe3Dff8M&method=FetchImageByUPC&upc=#{@item.upc}")
            image = Net::HTTP.get_response(imageUri)

            result = JSON.parse(image.body)["result"]

            @item.image = result["imageURL"]
            @item.imagethumb = result["imageThumbURL"]
            @item.save
          end
        end

        # if an item got saved, prep the response
        if (@item.brand && @item.description)
          @itemRequest = @item.brand + " " + @item.description
          @response = "You requested #{@itemRequest}. Let me see if that is approved..."
          # INSERT LOGIC FOR DETERMINING IF IT IS WIC APPROVED 
          # @response =
        else
          @response = "Hmm, I could not find an item with that UPC number. Please try again."
        end

      # DETERMINE RESPONSE WITH GENERIC REQUEST
      elsif @message.item_requested
        
      end
      
      # Send this response after parsing
      puts @response
    end

    puts "*********"
    puts @phone
    puts @response
    @client.account.sms.messages.create(
            from: TWILIO_CONFIG['from'],
            to: @phone,
            body: @response
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
