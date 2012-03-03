class ChangeDefaultTimezone < ActiveRecord::Migration
  def self.up
    change_column_default(:organizations, :time_zone, "Prague")
    change_column_default(:users, :time_zone, "Prague")
  end

  def self.down
    change_column_default(:organizations, :time_zone, "Eastern Time (US & Canada)")
    change_column_default(:users, :time_zone, "Eastern Time (US & Canada)")
  end
end
