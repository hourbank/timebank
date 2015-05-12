class AddLocationToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :location, :text
  end
end
