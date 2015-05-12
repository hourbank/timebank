class ApplicationController < ActionController::Base
  before_filter :configure_devise_params, if: :devise_controller?
    def configure_devise_params
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :services_offered, :city, :zipcode)
      end
    end

  # Need the Twilio Gem to send SMS messages
  require 'twilio-ruby'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def send_sms_to(user,message)
  	# Expecting that user parameter is the OBJECT of the user to receive the message
  	#NOTE: Other option to consider is defining this as user method: user.send_sms(message)
  	phone = user.phone

    message = "Hello "+user.first_name+"! "+message

  	# This is the Twillio account information (SID and auth_token for whichever account we are using)
  	account_sid = 'ACd9d81b036bad423457caf7ec9f506227' 
  	auth_token = '2e9b24ce85e18f2e6773043efe25bca8'

	  @client = Twilio::REST::Client.new account_sid, auth_token

	  message = @client.account.messages.create(
		 :body => message,
		 :to => "+1" + phone,
		 :from => "+14155992671")
  end
end
