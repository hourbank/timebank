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
			# INCLUDE THESE LINES IF WE UPDATE EXCHANGE TABLE WITH THESE COLUMNS
			#title: which_service_request.title,
			#location: which_service_request.location,
			proposed: true,
			proposed_date: Date.today,
			accepted: false,
			delivered: false,
			confirmed: false,
			service_requested_id: which_sr
			})

		#Send SMS to Recipient (i.e., person getting service)
		message = "Someone responded to your Service Request. Log in to your Timebank account for more info."
		# Another option for text: "Someone is interested in your post. Please log into your account to view more information.\n-The TimeBank Team"

		send_sms_to(which_service_request.recipient, message)

		#Redirect to Exchange show page
		redirect_to @proposed_exchange
	end

	def show
		@exchange = Exchange.find(params[:id])
	end
end
