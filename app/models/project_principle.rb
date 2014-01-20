class ProjectPrinciple < ActiveRecord::Base
  belongs_to :project
  belongs_to :principle
end