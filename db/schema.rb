# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110623071724) do

  create_table "activities", :force => true do |t|
    t.string    "package_id"
    t.string    "activity_lang"
    t.string    "default_currency"
    t.string    "hierarchy"
    t.string    "last_updated"
    t.string    "reporting_org"
    t.string    "reporting_org_ref"
    t.string    "reporting_org_type"
    t.string    "funding_org"
    t.string    "funding_org_ref"
    t.string    "funding_org_type"
    t.string    "extending_org"
    t.string    "extending_org_ref"
    t.string    "extending_org_type"
    t.string    "implementing_org"
    t.string    "implementing_org_ref"
    t.string    "implementing_org_type"
    t.string    "recipient_region"
    t.string    "recipient_region_code"
    t.string    "recipient_country"
    t.string    "recipient_country_code"
    t.string    "collaboration_type"
    t.string    "collaboration_type_code"
    t.string    "default_flow_type"
    t.string    "default_flow_type_code"
    t.string    "default_aid_type"
    t.string    "default_aid_type_code"
    t.string    "default_finance_type"
    t.string    "default_finance_type_code"
    t.string    "iati_identifier"
    t.string    "title"
    t.text      "description"
    t.date      "date_start_actual"
    t.date      "date_start_planned"
    t.date      "date_end_actual"
    t.date      "date_end_planned"
    t.string    "status_code"
    t.string    "status"
    t.string    "contact_organisation"
    t.string    "contact_telephone"
    t.string    "contact_email"
    t.string    "contact_mailing_address"
    t.string    "default_tied_status"
    t.string    "default_tied_status_code"
    t.string    "legacy_data_name"
    t.string    "legacy_data_value"
    t.string    "legacy_data_iati_equivalent"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "activity_website"
    t.integer   "countryregion_id"
  end

  create_table "activities_organisations", :force => true do |t|
    t.integer   "activity_id"
    t.integer   "organisation_id"
    t.integer   "rel_type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "activities_policy_markers", :force => true do |t|
    t.integer   "activity_id"
    t.integer   "policy_marker_id"
    t.string    "significance"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "activities_sectors", :force => true do |t|
    t.integer   "activity_id"
    t.integer   "sector_id"
    t.float     "percentage"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "aggregations", :force => true do |t|
    t.string   "name"
    t.float    "value"
    t.integer  "contribs"
    t.string   "thecontroller"
    t.integer  "theid"
    t.string   "group"
    t.text     "man_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "longitude"
    t.text     "latitude"
  end

  create_table "countryregions", :force => true do |t|
    t.string    "country_name"
    t.string    "dac_country_code"
    t.string    "iso2"
    t.string    "iso3"
    t.string    "dac_region_code"
    t.string    "dac_region_name"
    t.string    "item_type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "longitude"
    t.text      "latitude"
  end

  create_table "isocodes", :force => true do |t|
    t.string    "country"
    t.string    "longitude"
    t.string    "latitude"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "organisations", :force => true do |t|
    t.string    "name"
    t.string    "ref"
    t.string    "orgtype"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "packages", :force => true do |t|
    t.string    "packageid"
    t.string    "name"
    t.string    "title"
    t.string    "version"
    t.string    "url"
    t.string    "author"
    t.string    "author_email"
    t.string    "maintainer"
    t.string    "maintainer_email"
    t.string    "notes"
    t.string    "licenseid"
    t.string    "state"
    t.string    "revisionid"
    t.string    "license"
    t.string    "tags"
    t.string    "groups"
    t.string    "groups_types"
    t.string    "donors"
    t.date      "activity_period_from"
    t.string    "verified"
    t.text      "iati_preview"
    t.string    "donors_type"
    t.string    "activity_count"
    t.string    "country"
    t.string    "donors_country"
    t.date      "activity_period_to"
    t.string    "ratings_average"
    t.string    "ratings_count"
    t.string    "resourcesid"
    t.string    "resources_packageid"
    t.string    "resources_url"
    t.string    "resources_format"
    t.text      "resources_description"
    t.string    "resources_hash"
    t.string    "resources_position"
    t.text      "ckan_url"
    t.text      "download_url"
    t.integer   "retrieved"
    t.date      "retrieved_date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "policy_markers", :force => true do |t|
    t.string    "text"
    t.string    "vocab"
    t.string    "code"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "related_activities", :force => true do |t|
    t.integer   "activity_id"
    t.string    "text"
    t.string    "ref"
    t.string    "reltype"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sectors", :force => true do |t|
    t.string    "text"
    t.string    "vocab"
    t.string    "code"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer   "activity_id"
    t.float     "value"
    t.string    "value_date"
    t.string    "value_currency"
    t.string    "transaction_type"
    t.string    "transaction_type_code"
    t.string    "provider_org"
    t.string    "provider_org_ref"
    t.string    "provider_org_type"
    t.string    "receiver_org"
    t.string    "receiver_org_ref"
    t.string    "receiver_org_type"
    t.string    "description"
    t.string    "transaction_date"
    t.string    "transaction_date_iso"
    t.string    "flow_type"
    t.string    "flow_type_code"
    t.string    "aid_type"
    t.string    "aid_type_code"
    t.string    "finance_type"
    t.string    "finance_type_code"
    t.string    "tied_status_code"
    t.string    "disbursement_channel_code"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

end
