class AddDefaultToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :default, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :organizations, :default
  end
end
