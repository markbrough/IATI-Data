class Transactionvalue < ActiveRecord::Migration
  def self.up
	case ActiveRecord::Base.connection.adapter_name
	when 'SQLite'
		change_table :transactions do |t|
	  	  t.change :value, :integer
		end
	when 'PostgreSQL'
	     execute %{ALTER TABLE "transactions" ALTER COLUMN value TYPE integer USING CAST(CASE value WHEN '' THEN NULL ELSE value END AS INTEGER)}
	else
	     raise 'Migration not implemented for this DB adapter'
	end
  end

  def self.down
  end
end
