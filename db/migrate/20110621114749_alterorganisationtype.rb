class Alterorganisationtype < ActiveRecord::Migration
  def self.up
	rename_column :organisations, :type, :reltype
  end

  def self.down
  end
end
