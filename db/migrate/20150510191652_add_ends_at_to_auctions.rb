class AddEndsAtToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :ends_at, :timestamp
    # izgleda da postojeanje kolone "ends_at" se tretira kao postojanje metoda u auctions klasi, pa se zato moze poslati kao argument u f.datetime_select :ends_at 
  end
end
