class Auction < ActiveRecord::Base
  belongs_to :product
  has_many :bids #ovako smo implementirali bids messege u Auctionu
  # ovako radi jer smo relaciju vec definisali sa strane Bid-a: tamo gde pise da Bid belongs to user i auction
  
  
  def top_bid
    bids.order(value: :desc).first
    # moramo implementirati bids message u auction, i to radimo gore
  end
  
  def current_bid
    top_bid.nil? ? value : top_bid.value
    # ako je value nil, idemo na inicijalnu vrednost, ako nije, idemo na top vrednost
  end
  
  def ended?
    ends_at < Time.now
    # atribut je samo ends_at bez znaka pitanja
  end
end
