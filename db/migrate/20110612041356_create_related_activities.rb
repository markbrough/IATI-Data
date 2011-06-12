class CreateRelatedActivities < ActiveRecord::Migration
  def self.up
    create_table :related_activities do |t|
      t.integer :activity_id
      t.string :text
      t.string :ref
      t.string :reltype

      t.timestamps
    end
  end

  def self.down
    drop_table :related_activities
  end
end
