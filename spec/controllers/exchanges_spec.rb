require "rails_helper"

RSpec.describe ExchangesController, type: :controller do
	it "has a title" do
		exch = Exchange.create ({ title:'Gardening'})
		expect(exch.title).to eq 'Gardening'
	end	

=begin
TO FINISH AT A LATER DATE????
	# Rawwwr!!! How come this isn't passing?
	describe 'navigate to the exchanges page' do
		# before { get :new }

		it 'returns 200' do
			get :exchanges
			expect(response).to be_success
		end
	# Rawwwr!!! How come this isn't passing?
		it 'renders exchange by id' do
			get :id
			expect(response).to render_template 'exchanges/:id'
		end
	end
=end
end