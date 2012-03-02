class AddLdapToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :uses_ldap_authentication, :boolean, :default => false
  end

  def self.down
    remove_column :users, :uses_ldap_authentication
  end
end
