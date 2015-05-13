require "rails_helper"

RSpec.describe ExchangesController, type: :controller do
	it "has a title" do
		exch = Exchange.create ({ title:'Gardening'})
		expect(exch.title).to eq 'Gardening'
	end	
end