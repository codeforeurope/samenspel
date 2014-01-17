class AddOrganizationToPrinciple < ActiveRecord::Migration
  def self.up
    add_column :principles, :organization_id, :integer
  end

  def self.down
    remove_column :principles, :organization_id
  end
end
