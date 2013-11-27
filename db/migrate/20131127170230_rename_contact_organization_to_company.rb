class RenameContactOrganizationToCompany < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :organization, :company
  end

  def self.down
    rename_column :contacts, :company, :organization
  end
end
