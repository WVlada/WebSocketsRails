class Product < ActiveRecord::Base
    belongs_to :user
    has_one :auction # ovime smo dobili pristup auction metodu dole
    
    def has_auction?
        auction.present?
        # u tom smislu, sa recju "auction" idemo do relationshipa
    end
end
