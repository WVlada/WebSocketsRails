require "test_helper"
require "place_bid"

class PlaceBidTest < MiniTest::Test

    def test_it_places_a_bid
        user = User.create! email: "vlada6@vlada.net", password: "password"
        anotheruser = User.create! email: "anothervlada6@vlada.net", password: "password"
        
        product = Product.create! name: "Some product"
        auction = Auction.create! value: 10, product_id: product.id

        service = PlaceBid.new value: 11, user_id: anotheruser, auction_id: auction.id 
        service.execute
        
        assert_equal 11, auction.current_bid
        
    end
end