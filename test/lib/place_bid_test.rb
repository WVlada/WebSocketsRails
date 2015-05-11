require "test_helper"
require "place_bid"

class PlaceBidTest < MiniTest::Test
    def setup
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean 
    
      @user = User.create! email: "1vlada6@vlada.net", password: "password"
      @anotheruser = User.create! email: "1anothervlada6@vlada.net", password: "password"
      @product = Product.create! name: "Some product"
      @auction = Auction.create! value: 10, product_id: product.id
      
    end
    
    def test_it_places_a_bid
        service = PlaceBid.new(
            value: 11,
            user_id: anotheruser.id,
            auction_id: auction.id
        )
        
        service.execute
        assert_equal 11, auction.current_bid
    end
    
    def test_fails_to_place_bid_under_current_value
        service = PlaceBid.new(
            value: 9,
            user_id: anotheruser.id,
            auction_id: auction.id
            ) # da ne moze sa manjim iznosom
    refute service.execute, "Bid should not be placed"
    end
    
    
    private
    
    attr_reader :user, :anotheruser, :product, :auction
end