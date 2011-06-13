class IatiregistryController < ApplicationController
  def getPackage
    @package = Package.find(params[:id])
	  pu = {}
	  pu[:retrieved] = 1
	  pu[:retrieved_date] = DateTime.now
	  @package.update_attributes(pu)

    # check if this package is already in db
    @thetext ='';
    @activity_exists = Activity.find_by_package_id(@package.packageid)
    if @activity_exists
	@thetext += "<p>The package <b>" + @package.name + "</b> (" + @package.title + ") has already been downloaded.</p>"
    else
	@thetext += "<p>Downloading new package <b>" + @package.name + "</b> (" + @package.title + ").</p>"
    url = @package.resources_url
	require 'net/http'
	require 'rexml/document'

	# get the XML data as a string
	xml_data = Net::HTTP.get_response(URI.parse(url)).body

	# parse XML tree elements
	@doc = REXML::Document.new(xml_data)
	@doc.elements.each('iati-activities') do |data|
		version = data.attributes["version"]
		generated_datetime = data.attributes["generated-datetime"]
		data.elements.each('iati-activity') do |activity| 
			a={}
			a[:package_id] = @package.packageid
			a[:activity_lang] = activity.attributes["xml:lang"] if activity.attributes["xml:lang"]
			a[:default_currency] = activity.attributes["default-currency"] if activity.attributes["default-currency"]
			a[:hierarchy] = activity.attributes["hierarchy"] if activity.attributes["hierarchy"]
			a[:last_updated] = activity.attributes["last-updated-datetime"] if activity.attributes["last-updated-datetime"]
			a[:reporting_org] = activity.elements["reporting-org"].text if activity.elements["reporting-org"]
			a[:reporting_org_ref] = activity.elements["reporting-org"].attributes["ref"] if activity.elements["reporting-org"].attributes["ref"]
			a[:reporting_org_type] = activity.elements["reporting-org"].attributes["type"] if activity.elements["reporting-org"].attributes["type"]
			a[:funding_org] =''
			a[:funding_org_ref] =''
			a[:funding_org_type] =''
			a[:extending_org] =''
			a[:extending_org_ref] =''
			a[:extending_org_type] =''
			a[:implementing_org] =''
			a[:implementing_org_ref] =''
			a[:implementing_org_type] =''
			
			activity.elements.each('participating-org') do |p|
				if p.attributes["role"] == 'Funding' 
					a[:funding_org] = p.text
					a[:funding_org_ref] = p.attributes["ref"] if p.attributes["ref"]
					a[:funding_org_type] = p.attributes["type"] if p.attributes["type"]
				end
				if p.attributes["role"] == 'Extending'	
					a[:extending_org] = p.text
					a[:extending_org_ref] = p.attributes["ref"] if p.attributes["ref"]
					a[:extending_org_type] = p.attributes["type"] if p.attributes["type"]
				end
				if p.attributes["role"] == 'Implementing'
					a[:implementing_org] = p.text
					a[:implementing_org_ref] = p.attributes["ref"] if p.attributes["ref"]
					a[:implementing_org_type] = p.attributes["type"] if p.attributes["type"]	
				end
			end
			a[:recipient_region] = activity.elements["recipient-region"].text if activity.elements["recipient-region"]
			a[:recipient_region_code] = activity.elements["recipient-region"].attributes["code"] if activity.elements["recipient-region"]

			a[:recipient_country] = activity.elements["recipient-country"].text if activity.elements["recipient-country"]
			a[:recipient_country_code] = activity.elements["recipient-country"].attributes["code"] if activity.elements["recipient-country"]

			a[:collaboration_type] = activity.elements["collaboration-type"].text if activity.elements["collaboration-type"]
			a[:collaboration_type_code] = activity.elements["collaboration-type"].attributes["code"] if activity.elements["collaboration-type"]

			a[:default_flow_type] = activity.elements["default-flow-type"].text if activity.elements["default-flow-type"]
			a[:default_flow_type_code] = activity.elements["default-flow-type"].attributes["code"] if activity.elements["default-flow-type"]

			a[:default_aid_type] = activity.elements["default-aid-type"].text if activity.elements["default-aid-type"]
			a[:default_aid_type_code] = activity.elements["default-aid-type"].attributes["code"] if activity.elements["default-aid-type"]

			a[:default_finance_type] = activity.elements["default-finance-type"].text if activity.elements["default-finance-type"]
			a[:default_finance_type_code] = activity.elements["default-finance-type"].attributes["code"] if activity.elements["default-finance-type"]

			sectors = []
			activity.elements.each('sector') do |s|
				sectors << {
					   :text => (s.text if s.text), 
					   :vocab => (s.attributes["vocabulary"] if s.attributes["vocabulary"]), 
					   :code => (s.attributes["code"] if s.attributes["code"]),
					   :percentage => (s.attributes["percentage"] if s.attributes["percentage"])
					  }
			end
			
			policy_markers = []
			activity.elements.each('policy-marker') do |pm|
				policy_markers << {
					   :text => (pm.text if pm.text), 
					   :vocab => (pm.attributes["vocabulary"] if pm.attributes["vocabulary"]), 
					   :significance => (pm.attributes["significance"] if pm.attributes["significance"]), 
					   :code => (pm.attributes["code"] if pm.attributes["code"])
					  }
			end
			
			a[:legacy_data_name] = (activity.elements["legacy-data"].attributes["name"] if activity.elements["legacy-data"])
			a[:legacy_data_value] = (activity.elements["legacy-data"].attributes["value"] if activity.elements["legacy-data"])
			a[:legacy_data_iati_equivalent] = (activity.elements["legacy-data"].attributes["iati-equivalent"] if activity.elements["legacy-data"])

			a[:iati_identifier] = activity.elements["iati-identifier"].text if activity.elements["iati-identifier"]
			a[:title] = activity.elements["title"].text if activity.elements["title"]
			a[:description] = activity.elements["description"].text if activity.elements["description"]
			a[:date_start_actual] = '';
			a[:date_start_planned] = ''
			a[:date_end_actual] = ''
			a[:date_end_planned] = ''
			activity.elements.each('activity-date') do |d|
				(a[:date_start_actual] = d.text) if d.attributes["type"] == 'start-actual'
				(a[:date_start_planned] = d.text) if d.attributes["type"] == 'start-planned'
				(a[:date_end_actual] = d.text) if d.attributes["type"] == 'end-actual'
				(a[:date_end_planned] = d.text) if d.attributes["type"] == 'end-planned'
			end

			# correct for dfid (leaves dates with 'Z' on the end)... think maybe this happens automatically??
			#a[:date_start_actual].chop!; a[:date_start_planned].chop!; a[:date_end_actual].chop!; a[:date_end_planned].chop! if @package.donors == 'dfid'

			a[:status_code] = activity.elements["activity-status"].attributes["code"] if activity.elements["activity-status"].attributes["code"]
			a[:status] = activity.elements["activity-status"].text if activity.elements["activity-status"]
			
			a[:contact_organisation] =''
			a[:contact_telephone] = ''
			a[:contact_email] = ''
			a[:contact_mailing_address] = ''
			activity.elements.each('contact-info') do |c|
			  a[:contact_organisation] = c.elements["organisation"].text if c.elements["organisation"]
			  a[:contact_telephone] = c.elements["telephone"].text if c.elements["telephone"]
			  a[:contact_email] = c.elements["email"].text if c.elements["email"]
			  a[:contact_mailing_address] = c.elements["mailing-address"].text if c.elements["mailing-address"]
			end
			a[:default_tied_status] = activity.elements["default-tied-status"].text if activity.elements["default-tied-status"]
			a[:default_tied_status_code] = activity.elements["default-tied-status"].attributes["code"] if activity.elements["default-tied-status"].attributes["code"]
			related_activity = []
			activity.elements.each('related-activity') do |rel|
				related_activity << {
					:text => rel.text,
					:ref => rel.attributes["ref"], 
					:reltype => rel.attributes["type"]
				}
			end
			@activity = Activity.new(a)

			  if @activity.save
				@thetext += "Saved package." + @activity.id.to_s
			  else
				@thetext += "Couldn't save package."
			  end

			transactions = []
			activity.elements.each('transaction') do |t|
				t.elements["transaction-date"].attributes["iso-date"].chop! if t.elements["transaction-date"].attributes["iso-date"] and @package.donors=='dfid'
				transactions << {
					:activity_id => (@activity.id),
					:value => (t.elements["value"].text if t.elements["value"].text),
					:value_date => (t.elements["value"].attributes["value-date"] if t.elements["value"].attributes["value-date"]),
					:value_currency => (t.elements["value"].attributes["currency"] if t.elements["value"].attributes["currency"]),
					:transaction_type => (t.elements["transaction-type"].text if t.elements["transaction-type"]),
					:transaction_type_code => (t.elements["transaction-type"].attributes["code"] if t.elements["transaction-type"].attributes["code"]),
					:provider_org => (t.elements["provider-org"].text if t.elements["provider-org"]),
					:provider_org_ref => (t.elements["provider-org"].attributes["ref"] if t.elements["provider-org"]),
					:provider_org_type => (t.elements["provider-org"].attributes["type"] if t.elements["provider-org"]),

					:receiver_org => (t.elements["receiver-org"].text if t.elements["receiver-org"]),
					:receiver_org_ref => (t.elements["receiver-org"].attributes["ref"] if t.elements["receiver-org"]),
					:receiver_org_type => (t.elements["receiver-org"].attributes["type"] if t.elements["receiver-org"]),

					:description => (t.elements["description"].text if t.elements["description"]),

					:transaction_date => (t.elements["transaction-date"].text if t.elements["transaction-date"]),
					:transaction_date_iso => (t.elements["transaction-date"].attributes["iso-date"] if t.elements["transaction-date"].attributes["iso-date"]),

			

					:flow_type => (t.elements["flow-type"].text if t.elements["flow-type"]),
					:flow_type_code => (t.elements["flow-type"].attributes["code"] if t.elements["flow-type"]),
					:aid_type => (t.elements["aid-type"].text if t.elements["aid-type"]),
					:aid_type_code => (t.elements["aid-type"].attributes["code"] if t.elements["aid-type"]),
					:finance_type => (t.elements["finance-type"].text if t.elements["finance-type"]),
					:finance_type_code => (t.elements["finance-type"].attributes["code"] if t.elements["finance-type"]),
					:tied_status_code => (t.elements["tied-status"].attributes["code"] if t.elements["tied-status"]),
					:disbursement_channel_code => (t.elements["disbursement-channel"].attributes["code"] if t.elements["disbursement-channel"]),
						}
			end
			transactions.each do |tr|
				@transaction = Transaction.new(tr)

				  if @transaction.save
					@thetext += "Saved transaction." + @transaction.id.to_s
				  else
					@thetext += "Couldn't save transaction."
				  end
			end
			sectors.each do |sr|
				thesr = Sector.find_by_text(sr[:text])
				sector_activities = {}
				sector_activities[:percentage] = (sr[:percentage] if sr[:percentage])
				sr.delete(:percentage)
				if thesr
				sector_activities[:sector_id] = thesr.id.to_s
				# Sector already exists, just add reference in relationship table
				else
				# Sector doesn't exist, so create it.
				@sector = Sector.new(sr)

				  if @sector.save
					@thetext += "Saved sector." + @sector.id.to_s
				  else
					@thetext += "Couldn't save sector."
				  end
				sector_activities[:sector_id] = @sector.id.to_s
				end

				sector_activities[:activity_id] = @activity.id.to_s

				@sector_activities = SectorsActivity.new(sector_activities)

				  if @sector_activities.save
					@thetext += "Saved sector." + @sector_activities.id.to_s
				  else
					@thetext += "Couldn't save sector."
				  end		
			end
			policy_markers.each do |pom|
				thepom = PolicyMarker.find_by_text(pom[:text])
				policy_markers_activities ={}
				policy_markers_activities[:significance] = (pom[:significance] if pom[:significance])
				pom.delete(:significance)

				if thepom
				policy_markers_activities[:policy_marker_id] = thepom.id.to_s
				# PM already exists, just add reference in relationship table
				else
				# PM doesn't exist, so create it.
				@pm = PolicyMarker.new(pom)

				  if @pm.save
					@thetext += "Saved policy marker." + @pm.id.to_s
				  else
					@thetext += "Couldn't save policy marker."
				  end
				policy_markers_activities[:policy_marker_id] = @pm.id.to_s
				end

				
				policy_markers_activities[:activity_id] = @activity.id.to_s
				@pma = PolicyMarkersActivity.new(policy_markers_activities)

				  if @pma.save
					@thetext += "Saved Policy Marker-Activity." + @pma.id.to_s
				  else
					@thetext += "Couldn't save Policy Marker-Activity."
				  end		
			end
			related_activity.each do |ra|
				ra[:activity_id] = @activity.id.to_s
				@ra = RelatedActivity.new(ra)
				if @ra.save
					@thetext += "Added activity relation " + @ra.id.to_s
				else
					@thetext += "Couldn't add activity relation " + @ra.id.to_s
				end
			end

		end 
	end

	end
	# end check if package exists already

  end
  def index
    # Let's look at the IATI Registry
    url = "http://iatiregistry.org/api/2/rest/package"
    puts url
    result = Net::HTTP.get(URI(url))
    packages = ActiveSupport::JSON.decode(result)
    @showpackages = ''
    @max = 5
    @count = 0
    #packages = packages.first(1)
    # check if package already has been downloaded
    packages.each do |x|
	thepackage = Package.find_by_packageid(x)
	if thepackage
	  @showpackages += "<br />Already got package " + thepackage.name
        else

	  
	    if (@count < @max)
	    # only get 2 packages
		  @count = @count +1
		  newpackage ={}
		  packageurl = "http://iatiregistry.org/api/2/rest/package/" + x
		  puts packageurl
		  packageresult = Net::HTTP.get(URI(packageurl))
		  package = ActiveSupport::JSON.decode(packageresult)
		  @showpackages +=  "<br />Found new package: <a href=\"get_package/" + package["id"] + "\">" + package["name"] + "</a> - " + package["title"] + "<br/>"
		  newpackage = package
		  # get other data you don't have
		  newpackage[:packageid] = package["id"]
		  newpackage[:tags] = package["tags"][0]
		  newpackage[:groups_types] = package["groups_types"][0]
		  newpackage[:groups] = package["groups"][0]
		  newpackage[:donors] = package["extras"]["donors"][0]
		  newpackage[:activity_period_from] = package["extras"]["activity_period-from"]
		  newpackage[:verified] = package["extras"]["verified"]
		  newpackage[:donors_type] = package["extras"]["donors_type"][0]
		  newpackage[:activity_count] = package["extras"]["activity_count"]
		  newpackage[:country] = package["extras"]["country"]
		  newpackage[:donors_country] = package["extras"]["donors_country"][0]
		  newpackage[:activity_period_to] = package["extras"]["activity_period-to"]
		  newpackage[:revisionid] = package["revision_id"]
		  newpackage.delete("revision_id")
		  newpackage[:licenseid] = package["license_id"]
		  newpackage.delete("license_id")
		  newpackage[:resourcesid] = package["resources"][0]["id"]
		  resourcesid = newpackage[:resourcesid]
		  newpackage[:iati_preview] = package["extras"]["iati:preview:"+resourcesid]
		  newpackage[:resources_packageid] = package["resources"][0]["package_id"]
		  newpackage[:resources_url] = package["resources"][0]["url"]
		  newpackage[:resources_format] = package["resources"][0]["format"]
		  newpackage[:resources_description] = package["resources"][0]["description"]
		  newpackage[:resources_hash] = package["resources"][0]["hash"]
		  newpackage[:resources_position] = package["resources"][0]["position"]

		  newpackage.delete("relationships")
		  newpackage.delete("extras")
		  newpackage.delete("resources")
		  
		  @package = Package.new(newpackage)

		  if @package.save
			@showpackages += "<font color=\"green\">Saved package.</font>"
		  else
			@showpackages += "<font color=\"red\">Couldn't save package.</font>"
		  end
	    end
        end
    end
  end
end
