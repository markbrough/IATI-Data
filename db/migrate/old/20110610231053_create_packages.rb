class CreatePackages < ActiveRecord::Migration
  def self.up
    drop_table :packages
    create_table :packages do |t|
      t.string :packageid
      t.string :name
      t.string :title
      t.string :version
      t.string :url
      t.string :author
      t.string :author_email
      t.string :maintainer
      t.string :maintainer_email
      t.string :notes
      t.string :licenseid
      t.string :state
      t.string :revisionid
      t.string :license
      t.string :tags
      t.string :groups
      t.string :groups_types
      t.string :donors
      t.date :activity_period_from
      t.string :verified
      t.text :iati_preview
      t.string :donors_type
      t.string :activity_count
      t.string :country
      t.string :donors_country
      t.date :activity_period_to
      t.string :ratings_average
      t.string :ratings_count
      t.string :resourcesid
      t.string :resources_packageid
      t.string :resources_url
      t.string :resources_format
      t.text :resources_description
      t.string :resources_hash
      t.string :resources_position
      t.text :ckan_url

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
