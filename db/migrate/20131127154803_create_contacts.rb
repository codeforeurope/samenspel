class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :organization
      t.string :location
      t.string :email
      t.string :phone_number
      t.text :address

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
