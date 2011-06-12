class CreatePolicyMarkers < ActiveRecord::Migration
  def self.up
    drop_table :policy_markers
    create_table :policy_markers do |t|
      t.string :text
      t.string :vocab
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :policy_markers
  end
end
