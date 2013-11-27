class Contact < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :phone_number, :email, :company, :location, :address, :organization_id

  belongs_to :organization

  validates_presence_of :last_name

end
