require "place_bid"

class BidsController < ApplicationController

    def create
        service = PlaceBid.new bid_params
    
        if service.execute
        redirect_to product_path(params[:product_id]), notice: "Bid je uspesno postavljen"
        else
        redirect_to product_path(params[:product_id]), alert: "Nesto je poslo naopacke!"
        end
    end
    
    def bid_params
        params.require(:bid).permit(:value).merge!(
            user_id: current_user.id,
            auction_id: params[:auction_id]
            )
    end
end