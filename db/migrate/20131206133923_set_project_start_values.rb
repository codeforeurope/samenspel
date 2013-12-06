class SetProjectStartValues < ActiveRecord::Migration
  def self.up
    Project.connection.execute("update projects set date_start=created_at")
  end

  def self.down
  end
end
