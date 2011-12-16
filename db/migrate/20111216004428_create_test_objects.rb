class CreateTestObjects < ActiveRecord::Migration
  def self.up
    create_table :test_objects do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :test_objects
  end
end
