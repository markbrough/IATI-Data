class Countryregion < ActiveRecord::Migration
  def self.up
      create_table :countryregions do |t|
	t.string :country_name
	t.string :dac_country_code
	t.string :iso2
	t.string :iso3
	t.string :dac_region_code
	t.string :dac_region_name
	t.string :type
      t.timestamps
	end
  end

  def self.down
	drop_table :countryregions
  end
end
