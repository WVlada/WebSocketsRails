class AuctionsController < ApplicationController
    def create
        product = Product.find params[:product_id]
        auction = Auction.new auction_params.merge! product_id: product.id
        if auction.save
            redirect_to product, notice: "Product was put to auction"
        else
            redirect_to product, alert: "Something went wrong"
        end
    end
    
    def auction_params
    params.require(:auction).permit(:value, :ends_at)
    # tek sad radi strftime metod na aukciji, jer smo pre ovoga taj metod pozivali na Nil klasu
    # i sad moram kroz konzolu da dodajem za proizvod 2 tu vrednost, jer sam je kreiirao pre ovoga
    # Auction.all
    # Auction.find(2).update_attribute(:ends_at, Time.now(2015, 5, 10, 21, 00)
    # svakako smo posle zamenili i taj metod, ali je update bio neophodan
    end
end