class Countryregiontype < ActiveRecord::Migration
  def self.up	
    rename_column :countryregions, :type, :item_type
  end

  def self.down
  end
end
