class ExchangesController < ApplicationController

before_action :logged_in?
before_action :your_exchange?, only: [:show, :accept_exchange, :confirm_exchange, :deliver_exchange]

	def proposal_by_provider
		which_sr = params[:id]
		#Create new record in Exchange

		which_service_request = ServiceRequest.find(which_sr)
		#which_service_request = service_request

		@proposed_exchange = Exchange.create({
			provided_by_id: current_user.id,
			received_by_id: which_service_request.requested_by_id,
			estimated_hours: which_service_request.estimated_hours,
			description: which_service_request.description,
			title: which_service_request.title,
			location: which_service_request.location,
			proposed: true,
			proposed_date: Date.today,
			accepted: false,
			delivered: false,
			confirmed: false,
			service_requested_id: which_sr
			})

		#Send SMS to Recipient (i.e., person getting service)
		message = "Someone is interested in your Service Request. Please log in to your Epoch account for more info. \n-The TimeBank Team"
	
		send_sms_to(which_service_request.recipient, message)

		#Redirect to Exchange show page
		redirect_to exchange_path(@proposed_exchange)
	end

	def show
		@exchange = Exchange.find(params[:id])
	end

	def accept_exchange

		@exchange = Exchange.find(params[:id])
		
		#Byebug
		#CHECK WHAT @EXCHANGE is and WHETHER it has service_requested_id

	  	# Check that there are sufficient hours in recipient's balance

	  	if @exchange.sufficient_balance?
	  		# Update Exchange status in database
	  		@exchange.update(accepted: true, accepted_date: Date.today)

	  		# Send SMS message to counter-party
	  		accepter_name = @exchange.accepting_party.first_name
			message = accepter_name+" accepted your proposal for an exchange! Please log in to your Epoch account for more info. \n-The Epoch Team"
		
			send_sms_to(@exchange.proposing_party, message)

	  		# Redirect to same page, but with updated status (no Ajax yet...)
	  		redirect_to exchange_path(@exchange)

	  	else 
	  		# Get here if balance is not enough for this exchange at this time.  Warn user
	  		flash.now[:alert] = 'You do not currently have enough hours in your account for this exchange.  Please provide some services to earn more hours, then come back to accept this exchange!'
	  	end

  	end

  	def deliver_exchange

		@exchange = Exchange.find(params[:id])
		new_hours = params[:exchange][:final_hours]
		
		# STILL NEED to ask PROVIDER what is # of final hours
		# FOR NOW JUST PASSING OVER ESTIMATED HOURS INTO FINAL HOURS!!!!

		# Update Exchange status in database
	  	@exchange.update(final_hours: new_hours, delivered: true, delivered_date: Date.today)

	  	# Send SMS message to counter-party
		message = @exchange.provider.first_name+" has provided you with help. Please finalize the exchange by logging in to your Epoch account. \n-The Epoch Team"
		
		send_sms_to(@exchange.recipient, message)

	  	# Redirect to same page, but with updated status (no Ajax yet...)
	  	redirect_to exchange_path(@exchange)

  	end

  	def confirm_exchange

		@exchange = Exchange.find(params[:id])

		if @exchange.recipient.time_balance > @exchange.final_hours
			# Recipient has enough hours, so proceed with "payment"

			# Update Exchange status in database
		  	@exchange.update(confirmed: true, confirmed_date: Date.today)

		  	# Transfer hours (amount is final_hours) from RECIPIENT to PROVIDER
		  	@exchange.transfer_hours

		  	# Send SMS message to Provider
			message = @exchange.recipient.first_name+" has confirmed your exchange.  Thank you for exchanging help with Epoch! "+@exchange.final_hours.to_s+" hour(s) have been added to your balance. \n-The Epoch Team"
			
			send_sms_to(@exchange.provider, message)

			# Send SMS message to Recipient
			message = "Thank you for confirming your exchange with "+@exchange.provider+". "+@exchange.final_hours.to_s+" hour(s) have been deducted from your account. \n-The Epoch Team"
			
			send_sms_to(@exchange.recipient, message)

		  	# Redirect to same page, but with updated status (no Ajax yet...)
		  	redirect_to exchange_path(@exchange)
   		 else
    		# Get here if balance is not enough for this exchange at this time.  Warn user
	  		flash.now[:alert] = 'You do not currently have enough hours in your account to pay for this exchange.  Please provide some services to earn more hours, then come back to confirm this exchange!'
	  	end
    end
 

	private

	def logged_in?
		if !user_signed_in?
			redirect_to "/"
		end
	end

	def your_exchange?
		@exchange = Exchange.find(params[:id])
	    if !(current_user == @exchange.recipient || current_user == @exchange.provider)
	      redirect_to users_account_path
	    end
  	end
end
