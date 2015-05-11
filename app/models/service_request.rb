class ServiceRequest < ActiveRecord::Base
  belongs_to :recipient, class_name: "User", foreign_key: "requested_by_id"

  # Allow access to all these attributes
  attr_reader :title, :description, :estimated_hours, :location, :timing, :requested_by_id

end
