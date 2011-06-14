class CreateActivitiesPolicyMarkers < ActiveRecord::Migration
  def self.up
    rename_table :policy_markers_activities, :activities_policy_markers
  end

  def self.down
    rename_table :activities_policy_markers, :policy_markers_activities
  end
end
