class ExchangesController < ApplicationController

	def proposal_by_provider(service_request_id)
		#Create new record in Exchange

		which_service_request = ServiceRequest.find(service_request_id)

		@proposed_exchange = Exchange.create({
			provided_by_id: #need current user id,
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
			service_request_id: service_request_id
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
end
