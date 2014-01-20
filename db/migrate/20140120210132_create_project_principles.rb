class CreateProjectPrinciples < ActiveRecord::Migration
  def self.up
    create_table :project_principles do |t|
      t.integer :project_id
      t.integer :principle_id
    end
    add_index :project_principles, :project_id
    add_index :project_principles, :principle_id
  end

  def self.down
    drop_table :project_principles
  end
end
