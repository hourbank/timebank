class Exchange < ActiveRecord::Base
  belongs_to :provider, class_name: "User", foreign_key: "provided_by_id"
  belongs_to :recipient, class_name: "User", foreign_key: "received_by_id"

  # Allow access to all these attributes
  # attr_reader :estimated_hours, :final_hours, :description, :proposed, :proposed_date, :accepted, :accepted_date, :delivered, :delivered_date, :confirmed, :confirmed_date, :service_request_id
  #if we add these fields to Exchange table-->  :location, :timing,:title

  def stage
	# This method takes in an exchange object and returns a hash with two key:values
	# "stage_name" ==> which is "Proposed" "Accepted" "Delievered" or "Confirmed"
	# "stage_number" ==> which is 1, 2 3 or 4 (in the same order)

	if this.confirmed
		@current_stage = {"stage_name":"Confirmed","stage_number":4}
	elsif this.delivered
		@current_stage = {"stage_name":"Delivered","stage_number":3}
	elsif this.accepted
		@current_stage = {"stage_name":"Accepted","stage_number":2}
	elsif this.proposed
		@current_stage = {"stage_name":"Proposed","stage_number":1}
	else 
		#Hopefully the following line will never be used
		@current_stage = {"stage_name":"Error with Exchange","stage_number":0}
	end
end

end
