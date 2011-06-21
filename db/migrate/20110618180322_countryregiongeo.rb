class Countryregiongeo < ActiveRecord::Migration
  def self.up
	change_table :countryregions do |t|
	  t.text :longitude
	  t.text :latitude
	end
  end

  def self.down
  end
end
