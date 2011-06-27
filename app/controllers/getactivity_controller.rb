class GetactivityController < ApplicationController

	def index
	  @t = []
	  @messages = ''
	  @transactions = Transaction.find(:all, :limit=>300)
	  @transactions.each do |transaction|
	    @activity = Activity.find(transaction.activity_id)
	    @ra_conditions = {}
	    # get parents
	    @ra_conditions[:reltype] = '1'
	    @related_activity = RelatedActivity.find_by_activity_id(@activity.id, :conditions=>@ra_conditions)
		@ra_iati_id = ''
		@ra_iati_id = @related_activity.ref if @related_activity
		@messages = @messages + @ra_iati_id
#		@related_activity.each do |ra|
#		  @ra_iati_id = ra.ref
#		  @messages = @messages + ra.ref
#		end
	  	@related_activity_details = Activity.find_by_iati_identifier(@ra_iati_id)


		@r_id = (@related_activity_details.id if @related_activity_details)
		@r_iati_identifier=(@related_activity_details.iati_identifier if @related_activity_details)
		@r_title=(@related_activity_details.title if @related_activity_details)
		@r_description=(@related_activity_details.description if @related_activity_details)

	    @t << {
		:t_id => transaction.id,
		:t_value => transaction.value,
		:t_value_date => transaction.value_date,
		:t_value_currency=> transaction.value_currency,
		:t_transaction_type=> transaction.transaction_type,
		:t_transaction_type_code=>transaction.transaction_type_code,
		:t_provider_org=>transaction.provider_org,
		:t_provider_org_ref=>transaction.provider_org_ref,
		:t_provider_org_type=>transaction.provider_org_type,
		:t_receiver_org=>transaction.receiver_org,
		:t_receiver_org_ref=>transaction.receiver_org_ref,
		:t_receiver_org_type=>transaction.receiver_org_type,
		:t_description=>transaction.description,
		:t_transaction_date=>transaction.transaction_date,
		:t_transaction_date_iso=>transaction.flow_type,
		:t_flow_type_code=>transaction.flow_type_code,
		:t_aid_type=>transaction.aid_type,
		:t_aid_type_code=>transaction.aid_type_code,
		:t_finance_type=>transaction.finance_type,
		:t_finance_type_code=>transaction.finance_type_code,
		:t_tied_status_code=>transaction.tied_status_code,
		:t_disbursement_channel_code=>transaction.disbursement_channel_code,
		:a_id => @activity.id,
		:a_package_id=>@activity.package_id,
		:a_activity_lang=>@activity.activity_lang,
		:a_default_currency=>@activity.default_currency,
		:a_hierarchy=>@activity.hierarchy,
		:a_last_updated=>@activity.last_updated,
		:a_reporting_org=>@activity.reporting_org,
		:a_reporting_org_ref=>@activity.reporting_org_ref,
		:a_reporting_org_type=>@activity.reporting_org_type,
		:a_funding_org=>@activity.funding_org,
		:a_funding_org_ref=>@activity.funding_org_ref,
		:a_funding_org_type=>@activity.funding_org_type,
		:a_extending_org=>@activity.extending_org,
		:a_extending_org_ref=>@activity.extending_org_ref,
		:a_extending_org_type=>@activity.extending_org_type,
		:a_implementing_org=>@activity.implementing_org,
		:a_implementing_org_ref=>@activity.implementing_org_ref,
		:a_implementing_org_type=>@activity.implementing_org_type,
		:a_recipient_region=>@activity.recipient_region,
		:a_recipient_region_code=>@activity.recipient_region_code,
		:a_recipient_country=>@activity.recipient_country,
		:a_recipient_country_code=>@activity.recipient_country_code,
		:a_collaboration_type=>@activity.collaboration_type,
		:a_collaboration_type_code=>@activity.collaboration_type_code,
		:a_default_flow_type=>@activity.default_flow_type,
		:a_default_flow_type_code=>@activity.default_flow_type_code,
		:a_default_aid_type=>@activity.default_aid_type,
		:a_default_aid_type_code=>@activity.default_aid_type_code,
		:a_default_finance_type=>@activity.default_finance_type,
		:a_default_finance_type_code=>@activity.default_finance_type_code,
		:a_iati_identifier=>@activity.iati_identifier,
		:a_title=>@activity.title,
		:a_description=>@activity.description,
		:a_date_start_actual=>@activity.date_start_actual,
		:a_date_start_planned=>@activity.date_start_planned,
		:a_date_end_actual=>@activity.date_end_actual,	
		:a_date_end_planned=>@activity.date_end_planned,
		:a_status_code=>@activity.status_code,
		:a_status=>@activity.status,
		:a_contact_organisation=>@activity.contact_organisation,
		:a_contact_telephone=>@activity.contact_telephone,
		:a_contact_email=>@activity.contact_email,
		:a_contact_mailing_address=>@activity.contact_mailing_address,
		:a_default_tied_status=>@activity.default_tied_status,
		:a_default_tied_status_code=>@activity.default_tied_status_code,
		:a_legacy_data_name=>@activity.legacy_data_name,
		:a_legacy_data_value=>@activity.legacy_data_value,
		:a_legacy_data_iati_equivalent=>@activity.legacy_data_iati_equivalent,
		:a_activity_website=>@activity.activity_website,
		:a_countryregion_id=>@activity.countryregion_id,
		:r_id=>@r_id,
		:r_iati_identifier=>@r_iati_identifier,
		:r_title=>@r_title,
		:r_description=>@r_description
		}
	  end
	end

	def exportactivities 


		require 'csv'
		require 'pp'
		csv_string = FasterCSV.generate do |csv|

		#header row
		csv << ["T id", "T value", "T value_date", "T value_currency", "T transaction_type", "T transaction_type_code", "T provider_org", "T provider_org_ref", "T provider_org_type", "T receiver_org", "T receiver_org_ref", "T receiver_org_type", "T description", "T transaction_date", "T transaction_date_iso", "T disbursement_channel_code", "a_id", "a_package_id",	"a_activity_lang",  "a_hierarchy", "a_last_updated", "a_reporting_org",  "a_reporting_org_ref", 	"a_reporting_org_type", "a_funding_org", "a_funding_org_ref", "a_funding_org_type", "a_extending_org", "a_extending_org_ref",  "a_extending_org_type", "a_implementing_org", "a_implementing_org_ref", "a_implementing_org_type", "a_recipient_region", "a_recipient_region_code", "a_recipient_country", "a_recipient_country_code", "a_collaboration_type", "a_collaboration_type_code", "a_default_flow_type", "a_default_flow_type_code", "a_default_aid_type", "a_default_aid_type_code", "a_default_finance_type", "a_default_finance_type_code", "a_iati_identifier", "a_title", "a_description", "a_date_start_actual", "a_date_start_planned", "a_date_end_actual", "a_date_end_planned", "a_status_code", "a_status", "a_contact_organisation", "a_contact_telephone", "a_contact_email", "a_contact_mailing_address", "a_default_tied_status", "a_default_tied_status_code", "a_legacy_data_name", "a_legacy_data_value", "a_legacy_data_iati_equivalent", "a_activity_website", "a_countryregion_id",  "r_id",  "r_iati_identifier", "r_title"]
	  @messages = ''
	  @transactions = Transaction.find(:all, :limit=>300)
	  @transactions.each do |transaction|
	    @activity = Activity.find(transaction.activity_id)
	    @ra_conditions = {}
	    # get parents
	    @ra_conditions[:reltype] = '1'
	    @related_activity = RelatedActivity.find_by_activity_id(@activity.id, :conditions=>@ra_conditions)
		@ra_iati_id = ''
		@ra_iati_id = @related_activity.ref if @related_activity
		@messages = @messages + @ra_iati_id
#		@related_activity.each do |ra|
#		  @ra_iati_id = ra.ref
#		  @messages = @messages + ra.ref
#		end
	  	@related_activity_details = Activity.find_by_iati_identifier(@ra_iati_id)


		@r_id = (@related_activity_details.id if @related_activity_details)
		@r_iati_identifier=(@related_activity_details.iati_identifier if @related_activity_details)
		@r_title=(@related_activity_details.title if @related_activity_details)
		@r_description=(@related_activity_details.description if @related_activity_details)
		# In DFID data: description is only in related activity.
		# In WB data: description is only in activity.
		# Description is from activity unless related_activity has a description

		if ((@r_description) and (@r_description != ''))
		  @a_description = @r_description
		else
		  @a_description = @activity.description
		end

		if ((transaction.value_currency) and (transaction.value_currency != ''))
		  @value_currency = transaction.value_currency
		else
		  @value_currency = @activity.default_currency
		end
		# finance type
		# tied aid status

		if ((transaction.flow_type) and (transaction.flow_type!=''))
		  @flow_type = transaction.flow_type
		  @flow_type_code = transaction.flow_type_code
		else
		  @flow_type = @activity.default_flow_type
		  @flow_type_code = @activity.default_flow_type_code
		end

		if ((transaction.aid_type) and (transaction.aid_type!=''))
		  @aid_type = transaction.aid_type
		  @aid_type_code = transaction.aid_type_code
		else
		  @aid_type = @activity.default_aid_type
		  @aid_type_code = @activity.default_aid_type_code
		end

		if ((transaction.finance_type) and (transaction.finance_type!=''))
		  @finance_type = transaction.finance_type
		  @finance_type_code = transaction.finance_type_code
		else
		  @finance_type = @activity.default_finance_type
		  @finance_type_code = @activity.default_finance_type_code
		end

		if ((transaction.finance_type) and (transaction.finance_type!=''))
		  @finance_type = transaction.finance_type
		  @finance_type_code = transaction.finance_type_code
		else
		  @finance_type = @activity.default_finance_type
		  @finance_type_code = @activity.default_finance_type_code
		end

		if ((transaction.tied_status_code) and (transaction.tied_status_code!=''))
		  @tied_status_code = transaction.tied_status_code
		  # tied_status Text doesn't appear in WB or DFID transactions.
		  @tied_status = ''
		else
		  @tied_status = @activity.default_tied_status
		  @tied_status_code = @activity.default_tied_status_code
		end

## HEADERS FOR REFERENCE

#  "T id", "T value", "T value_date", "T value_currency", "T transaction_type", "T transaction_type_code", "T provider_org", "T provider_org_ref", "T provider_org_type", "T receiver_org", "T receiver_org_ref", "T receiver_org_type", "T description", "T transaction_date", "T transaction_date_iso", "T disbursement_channel_code", "a_id", "a_package_id",	"a_activity_lang",  "a_hierarchy", "a_last_updated", "a_reporting_org",  "a_reporting_org_ref", 	"a_reporting_org_type", "a_funding_org", "a_funding_org_ref", "a_funding_org_type", "a_extending_org", "a_extending_org_ref",  "a_extending_org_type", "a_implementing_org", "a_implementing_org_ref", "a_implementing_org_type", "a_recipient_region", "a_recipient_region_code", "a_recipient_country", "a_recipient_country_code", "a_collaboration_type", "a_collaboration_type_code", "a_default_flow_type", "a_default_flow_type_code", "a_default_aid_type", "a_default_aid_type_code", "a_default_finance_type", "a_default_finance_type_code", "a_iati_identifier", "a_title", "a_description", "a_date_start_actual", "a_date_start_planned", "a_date_end_actual", "a_date_end_planned", "a_status_code", "a_status", "a_contact_organisation", "a_contact_telephone", "a_contact_email", "a_contact_mailing_address", "a_default_tied_status", "a_default_tied_status_code", "a_legacy_data_name", "a_legacy_data_value", "a_legacy_data_iati_equivalent", "a_activity_website", "a_countryregion_id",  "r_id",  "r_iati_identifier", "r_title"


		csv << [ transaction.id, transaction.value, transaction.value_date, @value_currency, transaction.transaction_type, transaction.transaction_type_code, transaction.provider_org, transaction.provider_org_ref, transaction.provider_org_type, transaction.receiver_org, transaction.receiver_org_ref, transaction.receiver_org_type, transaction.description, transaction.transaction_date, transaction.transaction_date_iso, transaction.disbursement_channel_code, @activity.id, @activity.package_id, @activity.activity_lang, @activity.hierarchy, @activity.last_updated, @activity.reporting_org, @activity.reporting_org_ref, @activity.reporting_org_type, @activity.funding_org, @activity.funding_org_ref, @activity.funding_org_type, @activity.extending_org, @activity.extending_org_ref, @activity.extending_org_type, @activity.implementing_org, @activity.implementing_org_ref, @activity.implementing_org_type, @activity.recipient_region, @activity.recipient_region_code, @activity.recipient_country, @activity.recipient_country_code, @activity.collaboration_type, @activity.collaboration_type_code, @flow_type, @flow_type_code, @aid_type, @aid_type_code, @finance_type, @finance_type_code, @activity.iati_identifier, @activity.title, @a_description, @activity.date_start_actual, @activity.date_start_planned, @activity.date_end_actual, @activity.date_end_planned, @activity.status_code, @activity.status, @activity.contact_organisation, @activity.contact_telephone, @activity.contact_email, @activity.contact_mailing_address, @tied_status, @tied_status_code, @activity.legacy_data_name, @activity.legacy_data_value, @activity.legacy_data_iati_equivalent, @activity.activity_website, @activity.countryregion_id, @r_id, @r_iati_identifier, @r_title ]
	  end
end
		send_data csv_string,
			:type =>'text/csv; charset=iso-8859-1; header=present',
			:diposition=> "attachment; filename=activitydata.csv"
	


	end

end
