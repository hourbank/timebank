class ServiceRequest < ActiveRecord::Base
  belongs_to :recipient, class_name: "User", foreign_key: "requested_by_id"

  # validates estimated hours is a number and is greater than 0
  validates :estimated_hours, :numericality => {:only_integer => true, :greater_than => 0}
  # validates :estimated_hours, :numericality => {:greater_than => 0}

  # Allow access to all these attributes
  # attr_reader :title, :description, :estimated_hours, :location, :timing, :requested_by_id
end
