class Exchange < ActiveRecord::Base
  belongs_to :provider, class_name: "User", foreign_key: "provided_by_id"
  belongs_to :recipient, class_name: "User", foreign_key: "received_by_id"
end
