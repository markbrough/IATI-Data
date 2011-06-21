class ActivitiesDescription < ActiveRecord::Migration
  def self.up
	change_table :activities do |t|
  	  t.change :value_date, :date
	end
  end

  def self.down
  end
end
