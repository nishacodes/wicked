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
        puts "&&&&"
        puts res
        # if there's results, save it in the items database
        if res.body

          item_info = JSON.parse(res.body)["result"]
          if item_info 
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
        end

        # if an item got saved, prep the response
        if @item
          @itemRequest = @item.brand + " " + @item.description
          
            puts "******"
            puts @item.upc
            @wicknown = Wic_item.find_by_upc(@message.body)
            if @wicknown != nil
              @response = "You requested #{@itemRequest}. Congrats, it is Wic approved!"
            # end
            elsif @wicknown == nil
              puts "known item?"
              puts @message.body
              puts (Known_item.find_by_upc(@message.body)).class
              @knownitem = Known_item.find_by_upc(@message.body)
              
              puts @knownitem
              if @knownitem != nil
                @notes = @knownitem.wic_notes
                if @knownitem.wic_score < 0.5
                  @response = "#{@itemRequest} is probably not approved. #{@notes}"
                # end
                elsif @knownitem.wic_score < 0.8
                 @response = "#{@itemRequest} is probably approved #{@notes}"
                # end
                else
                  @response = "#{@itemRequest} is approved! #{@notes}"
                end
              # end
            # else
             
              # end
            # end
              else 
                query = Wicrule.uniq.pluck(:product)
                longest_found = 0
                found = ""
                @result = query.each do |item|
                  a = Item.find_longest_common_substring(item, @item.category)
                  if a > longest_found && a >= (item.length - 1)
                    longest_found = a
                    found = item
                    @response = "Wic approves #{item}."
                  end
                if longest_found == 0
                  @response = "Sorry, Wic does not approve #{@itemRequest}"
                end

                  puts "-----"
                  puts @response
                  puts @response.class


                end
                # end
              end
            end
            


          # INSERT LOGIC FOR DETERMINING IF IT IS WIC APPROVED 
          # @response =
          # link to view of item page
        else
          # @response = "Hmm, I could not find an item with that UPC number. Please try again."
          @wicknown =  Wic_item.find_by_upc(@message.upc)
          if @wicknown != nil
            @response = "Congrats, you picked a Wic approved item!"
          else 
            @response = "Hmm, I could not find an item with that UPC number. Please try again."
          end
        end

      # DETERMINE RESPONSE WITH GENERIC REQUEST
      elsif @message.item_requested
        @response = "You want #{@message.item_requested}, eh? Let me see what I can find."
        @secondresponse = "Sorry, we are still working on that. Check back soon."

        # INSERT LOGIC TO SEARCH CATEGORIES FOR ITEM REQUESTED
        # Milk is a great choice! We found X types of milk approved by WIC. Click here to see them.
        # I'm sorry, milk is not approved by WIC. You might try... ???
        # link to view of results page 
      end
      
   
      
    end
    puts "*********"
    puts @phone
    puts @response
    # Send this response after parsing
    @client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: @phone,
      body: @response
    )

    @client.account.sms.messages.create(
      from: TWILIO_CONFIG['from'],
      to: @phone,
      body: @secondresponse
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
