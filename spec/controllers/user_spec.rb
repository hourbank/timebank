require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	it "has a first_name" do
		james = User.create ({ first_name:'James'})
		expect(james.first_name).to eq 'James'
	end	
end