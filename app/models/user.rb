class User < ActiveRecord::Base
  # For Devise authentication
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # For Paperclip file attachment as profile "avatar"
  #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # take all characters out of phone number except integers
  before_validation :strip_phone

  def strip_phone
    self.phone.gsub!(/[^0-9]/, '')
  end

  # validate that phone number is only 10 numbers
  validates_length_of :phone, :is => 10
  # validate that zipcode is only 5 numbers
  validates_length_of :zipcode, :is => 5

  # require all fields be filled out when registering
  validates_presence_of :first_name, :last_name, :phone, :services_offered, :city, :zipcode, :time_balance

  # For associations with Exchange (2 separate 1:many relationships)
  has_many :exchanges_provided, class_name: "Exchange", foreign_key: "provided_by_id"
  has_many :exchanges_received, class_name: "Exchange", foreign_key: "received_by_id"

  # For association with ServiceRequest
  has_many :service_requests, class_name: "ServiceRequest", foreign_key: "requested_by_id"

  # Allow access to all these attributes
  #attr_reader :first_name, :last_name, :email, :phone, :services_offered, :city, :zipcode, :hours_balance
end

