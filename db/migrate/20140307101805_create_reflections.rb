class CreateReflections < ActiveRecord::Migration
  def self.up
    create_table :reflections do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :name
      t.integer :last_comment_id
      t.integer :comments_count,  :default => 0,     :null => false
      t.text :watcher_ids
      t.boolean :deleted, :default => false, :null => false

      t.timestamps
    end

    add_index "reflections", ["deleted"], :name => "index_reflections_on_deleted"
    add_index "reflections", ["project_id"], :name => "index_reflections_on_project_id"

  end

  def self.down
    remove_index :reflections, ["deleted"]
    remove_index :reflections, ["project_id"]
    drop_table :reflections
  end
end
