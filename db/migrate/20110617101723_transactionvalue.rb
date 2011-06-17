class Transactionvalue < ActiveRecord::Migration
  def self.up
	change_table :transactions do |t|
  	  t.change :value, :float
	end
  end

  def self.down
  end
end
