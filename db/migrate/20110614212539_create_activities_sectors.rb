class CreateActivitiesSectors < ActiveRecord::Migration
  def self.up
    rename_table :sectors_activities, :activities_sectors
  end

  def self.down
    rename_table :activities_sectors, :sectors_activities
  end
end

