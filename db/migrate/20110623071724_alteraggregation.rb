class Alteraggregation < ActiveRecord::Migration
  def self.up
	change_table :aggregations do |t|
	  t.text :longitude
	  t.text :latitude
	end
  end

  def self.down
  end
end
