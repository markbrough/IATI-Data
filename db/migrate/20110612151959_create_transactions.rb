class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :activity_id
      t.string :value
      t.string :value_date
      t.string :value_currency
      t.string :transaction_type
      t.string :transaction_type_code
      t.string :provider_org
      t.string :provider_org_ref
      t.string :provider_org_type
      t.string :receiver_org
      t.string :receiver_org_ref
      t.string :receiver_org_type
      t.string :description
      t.string :transaction_date
      t.string :transaction_date_iso
      t.string :flow_type
      t.string :flow_type_code
      t.string :aid_type
      t.string :aid_type_code
      t.string :finance_type
      t.string :finance_type_code
      t.string :tied_status_code
      t.string :disbursement_channel_code

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
