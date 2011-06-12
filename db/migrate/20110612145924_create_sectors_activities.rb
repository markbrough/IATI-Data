class CreateSectorsActivities < ActiveRecord::Migration
  def self.up

    drop_table :sectors_activities
    create_table :sectors_activities do |t|
      t.integer :activity_id
      t.integer :sector_id
      t.float :percentage
      t.timestamps
    end
  end

  def self.down
    drop_table :sectors_activities
  end
end
