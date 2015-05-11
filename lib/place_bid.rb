class PlaceBid
# ova klasa treba da hendluje svu logiku o postavljanju bidova
    
    attr_reader :auction
    #na ovaj nacin ce biti public za napolje
    
    def initialize options
        @value = options[:value].to_f
        @user_id = options[:user_id]
        @auction_id = options[:auction_id]
    end
    
    def execute
        @auction = Auction.find @auction_id
        #na ovaj nacin ce biti public za napolje
        
        if @value <= auction.current_bid
        return false
        end
        
        bid = auction.bids.build value: @value, user_id: @user_id        
        
        if bid.save
            return true
        else
            return false
        end
    end
   
end