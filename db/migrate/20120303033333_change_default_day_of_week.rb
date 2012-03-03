class ChangeDefaultDayOfWeek < ActiveRecord::Migration
  def self.up
    change_column_default(:users, :first_day_of_week, "monday")
  end

  def self.down
    change_column_default(:users, :first_day_of_week, "sunday")
  end
end
