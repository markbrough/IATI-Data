class Countryregioncode < ActiveRecord::Migration
  def self.up
	change_table :activities do |t|
	  t.integer :recipient_countryregion_code
	end
  end

  def self.down
  end
end
