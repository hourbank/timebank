class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # allow Devise to add additional user sign up fields
  before_filter :configure_devise_params, if: :devise_controller?
    def configure_devise_params
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :services_offered, :city, :zipcode)
      end
    end

    def after_sign_in_path_for(resource)
      '/users/account'
    end

  # Need the Twilio Gem to send SMS messages
  require 'twilio-ruby'

  def send_sms_to(user,message)
  	# Expecting that user parameter is the OBJECT of the user to receive the message
  	#NOTE: Other option to consider is defining this as user method: user.send_sms(message)
  	phone = user.phone

    message = "Hello "+user.first_name+"! "+message

  	# This is the Twillio account information (SID and auth_token for whichever account we are using)
    # New real SID
    account_sid = 'AC91d1e215d5a331ce1abc7decf99384cd' 
  	
    auth_token = ENV["api_authorization_token"]

	  @client = Twilio::REST::Client.new account_sid, auth_token

	  message = @client.account.messages.create(
		 :body => message,
		 :to => "+1" + phone,
		 :from => "+16503895939")
  end

  def total_bank_hours
    # Calculate total hours exchanged on the site to display as measure of impact
    all_ex = Exchange.all
    memo = 0
    all_ex.each do |e|
      if e.final_hours != nil
        memo = memo + e.final_hours
      end
    end

   return memo
  end

end
