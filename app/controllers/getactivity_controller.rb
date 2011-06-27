class GetactivityController < ApplicationController

	def index
	  @t = []
	  @transactions = Transaction.find(:all, :limit=>100)
	  @transactions.each do |transaction|
	    @activity = Activity.find(transaction.activity_id)
	    @ra_conditions = {}
	    @ra_conditions[:activity_id] = @activity[:id]
	    @ra_conditions[:reltype] = 1
	    @related_activity = RelatedActivity.find(:all, :conditions=>@ra_conditions)
		@related_activity_iati_ID = @related_activity[:ref]
	  	@related_activity_details = Activity.find_by_iati_identifier(@related_activity_iati_ID, :limit=>1)
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
		:a_countryregion_id=>@activity.countryregion_id
		}
	  end
	end

end
