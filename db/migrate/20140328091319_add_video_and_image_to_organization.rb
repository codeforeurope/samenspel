class AddVideoAndImageToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :video_url, :string
    add_column :organizations, :thumbnail_url, :string
  end

  def self.down
    remove_column :organizations, :thumbnail_url
    remove_column :organizations, :video_url
  end
end
