class Countryregionid < ActiveRecord::Migration
  def self.up
	rename_column :activities, :recipient_countryregion_code, :countryregion_id
	create_table :activities_organisations do |t|
          t.integer :activity_id
          t.integer :organisation_id
          t.integer :rel_type
          t.timestamps
        end
	create_table :organisations do |t|
          t.string :name
          t.string :ref
          t.string :type
          t.timestamps
        end
  end

  def self.down
	drop_table :organisations
	drop_table :activities_organisations
  end
end
