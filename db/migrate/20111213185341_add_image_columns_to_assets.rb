class AddImageColumnsToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :assets, :image
  end
end