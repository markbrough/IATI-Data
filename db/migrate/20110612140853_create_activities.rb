class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :package_id
      t.string :activity_lang
      t.string :default_currency
      t.string :hierarchy
      t.string :last_updated
      t.string :reporting_org
      t.string :reporting_org_ref
      t.string :reporting_org_type
      t.string :funding_org
      t.string :funding_org_ref
      t.string :funding_org_type
      t.string :extending_org
      t.string :extending_org_ref
      t.string :extending_org_type
      t.string :implementing_org
      t.string :implementing_org_ref
      t.string :implementing_org_type
      t.string :recipient_region
      t.string :recipient_region_code
      t.string :recipient_country
      t.string :recipient_country_code
      t.string :collaboration_type
      t.string :collaboration_type_code
      t.string :default_flow_type
      t.string :default_flow_type_code
      t.string :default_aid_type
      t.string :default_aid_type_code
      t.string :default_finance_type
      t.string :default_finance_type_code
      t.string :iati_identifier
      t.string :title
      t.string :description
      t.date :date_start_actual
      t.date :date_start_planned
      t.date :date_end_actual
      t.date :date_end_planned
      t.string :status_code
      t.string :status
      t.string :contact_organisation
      t.string :contact_telephone
      t.string :contact_email
      t.string :contact_mailing_address
      t.string :default_tied_status
      t.string :default_tied_status_code
      t.string :legacy_data_name
      t.string :legacy_data_value
      t.string :legacy_data_iati_equivalent

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
