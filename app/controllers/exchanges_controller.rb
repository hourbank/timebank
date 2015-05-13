class ExchangesController < ApplicationController

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
			message = "Someone accepted your proposal for an exchange! Please log in to your Timebank account for more info. \n-The TimeBank Team"
		
			send_sms_to(@exchange.proposing_party, message)

	  		# Redirect to same page, but with updated status (no Ajax yet...)
	  		redirect_to exchange_path(@exchange)

	  	else 
	  		# Get here if balance is not enough for this exchange at this time.  Warn user
	  		flash.now[:alert] = 'You do not currently have enough hours in your account for this exchange.  Please provide some services to earn more hours, then come back to accept this exchange!'
	  	end

  	end

end
