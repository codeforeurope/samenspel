class Principle < ActiveRecord::Base

  attr_accessible :title, :organization_id
  belongs_to :organization
  validates_presence_of :title
end
