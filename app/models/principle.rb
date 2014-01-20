class Principle < ActiveRecord::Base

  attr_accessible :title, :organization_id
  belongs_to :organization

  has_many :project_principles
  has_many :projects, through: :project_principles

  validates_presence_of :title
end
