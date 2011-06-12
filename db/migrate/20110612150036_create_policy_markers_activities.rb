class CreatePolicyMarkersActivities < ActiveRecord::Migration
  def self.up
    create_table :policy_markers_activities do |t|
      t.integer :activity_id
      t.integer :policy_marker_id
      t.string :significance
      t.timestamps
    end
  end

  def self.down
    drop_table :policy_markers_activities
  end
end
