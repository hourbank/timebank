require 'rails_helper'

RSpec.describe User, type: :model do
	describe 'Attributes' do
		it { is_expected.to respond_to :first_name}
		it { is_expected.to respond_to :last_name }
    	it { is_expected.to respond_to :email }
    	it { is_expected.to respond_to :phone }
    	it { is_expected.to respond_to :services_offered }
    	it { is_expected.to respond_to :city }
    	it { is_expected.to respond_to :zipcode }
    	it { is_expected.to respond_to :encrypted_password }
    	it { is_expected.to respond_to :time_balance }
	end
=begin
	TO FINISH AT A LATER DATE???
  describe 'Database' do
  	it { is_expected.to have_db_column :first_name }
  	it { is_expected.to have_db_column :last_name }
    it { is_expected.to have_db_column :email }
  end

  describe 'Validations' do
  	it { is_expected.to validate_presence_of :email }
  	it { is_expected.to validate_presence_of :phone }
  end
=end

end