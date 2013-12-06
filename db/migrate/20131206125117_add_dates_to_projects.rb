class AddDatesToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :date_start, :datetime
    add_column :projects, :date_end, :datetime
  end

  def self.down
    remove_column :projects, :date_end
    remove_column :projects, :date_start
  end
end
