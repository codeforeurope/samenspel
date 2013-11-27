class AddContactToOrganization < ActiveRecord::Migration
  def self.up
    add_column :contacts, :organization_id, :integer
  end

  def self.down
    remove_column :contacts, :organization_id
  end
end
