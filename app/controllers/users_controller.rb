class UsersController < ApplicationController
	def index
		@all_users = User.all
	end

	def show
	end

	def account
		#Generate the account dashboard page for the currently logged-in user
		@user = current_user
		
	end
end
