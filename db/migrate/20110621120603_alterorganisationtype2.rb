class Alterorganisationtype2 < ActiveRecord::Migration
  def self.up
	rename_column :organisations, :reltype, :orgtype
  end

  def self.down
  end
end
