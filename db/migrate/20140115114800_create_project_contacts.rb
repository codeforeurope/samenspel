class CreateProjectContacts < ActiveRecord::Migration
  def self.up
    create_table :project_contacts do |t|
      t.integer :project_id
      t.integer :contact_id
    end
    add_index :project_contacts, :project_id
    add_index :project_contacts, :contact_id
  end

  def self.down
    drop_table :project_contacts
  end
end
