class ServiceRequest < ActiveRecord::Base
  belongs_to :recipient, class_name: "User", foreign_key: "requested_by_id"
end
