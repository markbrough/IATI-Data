class ActivitiesDescription < ActiveRecord::Migration
  def self.up
	change_table :activities do |t|
  	  t.change :description, :text
	end
  end

  def self.down
  end
end
