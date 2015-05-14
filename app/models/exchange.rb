class Exchange < ActiveRecord::Base
  belongs_to :provider, class_name: "User", foreign_key: "provided_by_id"
  belongs_to :recipient, class_name: "User", foreign_key: "received_by_id"

  def self.total_hours
    memo = 0
    self.all.each do |each_exchange|
      memo = memo + each_exchange.final_hours
    end

    return memo
  end

  def stage
	# This method takes in an exchange object and returns a hash with two key:values
	# "stage_name" ==> which is "Proposed" "Accepted" "Delievered" or "Confirmed"
	# "stage_number" ==> which is 1, 2 3 or 4 (in the same order)
	#byebug

		if self.confirmed
			@current_stage = {stage_name: "Confirmed", stage_number: 4}
		elsif self.delivered
			@current_stage = {stage_name: "Delivered", stage_number: 3}
		elsif self.accepted
			@current_stage = {stage_name: "Accepted", stage_number: 2}
		elsif self.proposed
			@current_stage = {stage_name: "Proposed", stage_number: 1}
		else 
			#Hopefully the following line will never be used
			@current_stage = {stage_name: "Error with Exchange model stage method", stage_number: 0}
		end

		return @current_stage
	end

  def accepting_party
  	# If there is a service_requested_id in the Exchange, then we know that the PROVIDER proposed (from a ServiceRequest), and RECIPIENT can accept
  	# If service_requested_id is NIL, then we know that the RECIPIENT proposed (from a profile page), and PROVIDER can accept

  	if self.service_requested_id == nil
  		# So RECIPIENT proposed and PROVIDER is counter-party who can accept
  		counter_party = self.provider
  	elsif self.service_requested_id > 0
  		# So Exchange was created from a ServiceRequest by PROVIDER, so RECIPIENT is counter-party who can accept
  		counter_party = self.recipient
  	end

  	return counter_party

  end

  def proposing_party
  	# The proposing_party is the OPPOSITE of the accepting_party -- and is only needed for the SMS message after acceptance is done

	if self.service_requested_id == nil
  		party = self.recipient
  	elsif self.service_requested_id > 0
  		party = self.provider
  	end

  	return party

  end

  def sufficient_balance?
  	# Check to see if the RECIPIENT of the proposed Exchange has enough hours in his/her account to handle this exchange
  	# "Enough" means a) time_balance - estimated_hours >= -2 and b) time_balance > 0
  	# In other words, you can go into debt by up to 2 hours, but only if you are not in debt yet

  	if self.recipient.time_balance - self.estimated_hours >= -2 && self.recipient.time_balance >= 0
  		approved = true
  	else approved = false
  	end

  	return approved
  end

  def transfer_hours
    # Transfer hours from RECIPIENT of exchange to PROVIDER of exchange
    # The number of hours is the "final_hours" column of Exchange table

    # For now, allowing RECIPIENT to pay for Exchange, regardless of time_balance.  Idea is that it is better to pay the PROVIDER and let RECIPIENT go into debt.  Limitation on bad user behavior is that RECIPIENT cannot Accept any further proposals if time_balance is negative (or exchange would push him/her lower than -2)

    ActiveRecord::Base.transaction do
      # Remove hours from RECIPIENT balance
      new_recipient_balance = self.recipient.time_balance - self.final_hours
      # Put this new value into database for recipient
      who_from = User.find(self.recipient.id)
      who_from.update(time_balance: new_recipient_balance)

      # Add hours to PROVIDER balance
      new_provider_balance = self.provider.time_balance + self.final_hours
      # Put this new value into database for provider
      who_to = User.find(self.provider.id)
      who_to.update(time_balance: new_provider_balance)
    end

    # IF WE DECIDE IN THE FUTURE TO IMPLEMENT SOME TYPE OF BALANCE CHECKING, WE WILL USE THE CODE BELOW.  DO NOT DELETE IT.

    # # Confirm that RECIPIENT has sufficient hours in time_balance
    # if self.recipient.time_balance > self.final_hours
    #   ActiveRecord::Base.transaction do
    #     # Remove hours from RECIPIENT balance
    #     new_recipient_balance = self.recipient.time_balance - self.final_hours
    #     # Put this new value into database for recipient
    #     who_from = User.find(self.recipient.id)
    #     who_from.update(time_balance: new_recipient_balance)

    #     # Add hours to PROVIDER balance
    #     new_provider_balance = self.provider.time_balance + self.final_hours
    #     # Put this new value into database for provider
    #     who_to = User.find(self.provider.id)
    #     who_to.update(time_balance: new_provider_balance)
    #   end
    # else
    #   #Should never get here, because should test in controller
    #   alert "Not enough hours for this transfer"
    # end
  
    # This 'end' is end of transfer_hours method
  end

  def your_exchange?
    if !(current_user == self.recipient || current_user == self.provider)
      redirect_to users_account_path
    end
  end

end
