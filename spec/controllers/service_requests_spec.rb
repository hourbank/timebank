require "rails_helper"

RSpec.describe ServiceRequestsController, type: :controller do
	it "has a first_name" do
		@sr = ServiceRequest.create ({ title:'Music Lessons'})
		expect(@sr.title).to eq 'Music Lessons'
	end	

	describe 'navigate to a new Service request' do

		it 'returns 200' do
			get :new
			expect(response).to be_success
		end

		it 'renders service_requests/new' do
			get :new
			expect(response).to render_template 'service_requests/new'
		end
	end
end