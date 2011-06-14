class Activitywebsite < ActiveRecord::Migration
  def self.up
	change_table :activities do |t|
	  t.text :activity_website
	end
  end

  def self.down
  end
end
