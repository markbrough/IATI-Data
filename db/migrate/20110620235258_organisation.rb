class Organisation < ActiveRecord::Migration
  def self.up
      create_table :organisations do |t|
	t.string :organisation_name
      t.timestamps
	end
  end

  def self.down
  end
end
