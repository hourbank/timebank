class UsersController < ApplicationController
before_action :logged_in?

	def index
		@all_users = User.all.order(:first_name)
	end

	def show
		@user = User.find(params[:id])
		@current_user = current_user
		@requests = ServiceRequest.where(requested_by_id: @user.id).order(created_at: :desc)
		
		#DO NOT USE - @requests = ServiceRequest.all.order(created_at: :desc)
	end

	def account
		#Generate the account dashboard page for the currently logged-in user
		@user = current_user
		@requests = ServiceRequest.where(requested_by_id: @user.id).order(created_at: :desc)
		#DO NOT USE - @requests = ServiceRequest.all.order(created_at: :desc)
		@exchanges_as_provider = Exchange.where(provided_by_id: @user.id).order(created_at: :desc)
		@exchanges_as_recipient = Exchange.where(received_by_id: @user.id).order(created_at: :desc)
		@exchanges = @exchanges_as_provider + @exchanges_as_recipient

		#@exchanges = Exchange.where(provided_by_id: @user.id).or(Exchange.where(received_by_id: @user.id)) #.order(created_at: :desc)
		#where(provided_by_id: @user.id OR received_by_id: @user.id).order(created_at: :desc)

		#@exchanges= Exchange.all.order(created_at: :desc)
	end

	private

	def logged_in?
		if !user_signed_in?
			flash[:error] = "Please sign in first!"
			redirect_to "/users/sign_in"
		end
	end
end
