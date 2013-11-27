class AddGoalToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :goal, :text
  end

  def self.down
    remove_column :projects, :goal
  end
end
