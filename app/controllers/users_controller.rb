class UsersController < ApplicationController
	def index
		@all_users = User.all
	end

	def show
		@user = User.find(params[:id])
		@current_user = current_user
		@requests = ServiceRequest.all
	end

	def account
		#Generate the account dashboard page for the currently logged-in user
		@user = current_user
		@requests = ServiceRequest.all
		@exchanges= Exchange.all
	end
end
