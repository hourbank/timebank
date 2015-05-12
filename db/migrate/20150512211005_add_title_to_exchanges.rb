class AddTitleToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :title, :string
  end
end
