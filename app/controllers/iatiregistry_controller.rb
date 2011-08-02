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
	
	@thetext += "<p>There are no activities in this package.</p>" unless @doc.elements['iati-activities']
	@doc.elements.each('iati-activities') do |data|
		version = data.attributes["version"]
		generated_datetime = data.attributes["generated-datetime"]
		
		
		data.elements.each('iati-activity') do |activity| 
			a={}
			a[:package_id] = @package.packageid
			a[:activity_lang] = activity.attributes["xml:lang"] if activity.attributes["xml:lang"]
			# if default currency isn't set in the activity, then check the headers... Particularly important for transactions later on!
			a[:default_currency] = (activity.attributes["default-currency"] if activity.attributes["default-currency"])
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
			
			# This needs to be normalised :(
			# Get all participating-organisations and their relationships to this activity.
			organisations = []
			activity.elements.each('participating-org') do |p|
				organisations << {
					   :name => (p.text if p.text), 
					   :ref => (p.attributes["ref"] if p.attributes["ref"]), 
					   :orgtype => (p.attributes["type"] if p.attributes["type"]),
					   :reltype => (p.attributes["role"] if p.attributes["role"])
					  }
			end

=begin
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
=end
				# Attach activity to a country (preferably) or region
				# Try and find country by iso2 code
				# if found, use that countryregion code (countryregion id)
				# Otherwise, try and find a region to attach to.
			if activity.elements["recipient-country"]
				@recipient_country_code = activity.elements["recipient-country"].attributes["code"]
				if @countryregion = Countryregion.find_by_iso2(@recipient_country_code)
				   a[:countryregion_id] = @countryregion.id
				else
				   c = {}
				   c[:iso2] = activity.elements["recipient-country"].attributes["code"]
				   c[:country_name] = activity.elements["recipient-country"].text
				   c[:item_type] = "Country"
				   @countryregion = Countryregion.new(c)
				   @countryregion.save
				   a[:countryregion_id] = @countryregion.id
				end
			elsif activity.elements["recipient-region"]

				# This is difficult because DFID (maybe others too) use "Recipient Region" without defining a code.
				# So, we have to check Countryregion for
				#  a) dac_region_code
				# or
				#  b) country_name = activity.elements["recipient_region"].text (country name = region name for regions)
				# Rather than just dac_region_code=...attributes["code"]
				#
				# Not sure how to combine different donors' definitions. And what happens if they use the same word for
				# different things? Let's not worry too much for now :)
					
				@region_name = activity.elements["recipient-region"].text
				@region_code = activity.elements["recipient-region"].attributes["code"]
				# country_code is also the region code when it's a region
				# country_name is also the region_name when it's a region.
				if @countryregion = Countryregion.find_by_dac_country_code(@region_code)
				  a[:countryregion_id] = @countryregion.id

				# not a standard region, so try and find it by the name of the region...
				elsif @countryregion = Countryregion.find_by_country_name(@region_name)
				  a[:countryregion_id] = @countryregion.id

				# couldn't find that same name of region, so create a new one
				else
				  c = {}				
				  c[:country_name] = activity.elements["recipient-region"].text				
				  c[:dac_region_name] = activity.elements["recipient-region"].text
				  c[:dac_region_code] = activity.elements["recipient-region"].attributes["code"]
				  c[:item_type] = "Region"
				  @countryregion = Countryregion.new(c)
				  if @countryregion.save
					@thetext += "Saved a region "
				  end
				  a[:countryregion_id] = @countryregion.id
				end
			end
			#IN many cases (esp. hierarchy-1 activities) there will not be a recipient country or region code.

			# this is mostly defunct now as it's been normalised. But let's keep for posterity.
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
			# DFID has often not provided Vocab, so assume DAC.
				@vocab = ''
				if (s.attributes["vocabulary"] and s.attributes["vocabulary"] != '')
				  # RO = Reporting Organisation's own codes (the donor)
				  if (s.attributes["vocabulary"] == 'RO')
				    @vocab = @package.donors
				  else
				    @vocab = s.attributes["vocabulary"]
				  end
				else
				  @vocab = "DAC"
				end
				sectors << {
					   :text => (s.text if s.text), 
					   :vocab => @vocab, 
					   :code => (s.attributes["code"] if s.attributes["code"]),
					   :percentage => (s.attributes["percentage"] if s.attributes["percentage"])
					  }
			end

			# Do DFID legacy sector markers too (presume these are DFID-specific codes, but they are often similar to DAC)
			if @package.donors == 'dfid'
			  activity.elements.each('legacy-data') do |ld|
				  @vocab = 'DFID'
				  sectors << {
					     :text => (ld.attributes["name"] if ld.attributes["name"]),
					     :vocab => @vocab, 
					     :code => (ld.attributes["value"] if ld.attributes["value"]),
					     :percentage => (ld.text if ld.text)
					    }
			  end
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
				# Hewlett puts this in ISO-date attrib only (according to IATI Standard)
				# DFID puts it in text only
				# WB puts it in both
				if d.attributes["type"] == 'start-actual'
				  if (d.text and d.text != '')
				    a[:date_start_actual] = d.text
				  else
				    a[:date_start_actual] = d.attributes["iso-date"]
				  end
				elsif d.attributes["type"] == 'start-planned'
				  if (d.text and d.text != '')
				    a[:date_start_planned] = d.text 
				  else
				    a[:date_start_planned] = d.attributes["iso-date"]
				  end
				elsif d.attributes["type"] == 'end-actual'
				  if (d.text and d.text != '')
				    a[:date_end_actual] = d.text
				  else
				    a[:date_end_actual] = d.attributes["iso-date"]
				  end
				elsif d.attributes["type"] == 'end-planned'
				  if (d.text and d.text != '')
				    a[:date_end_planned] = d.text
				  else
				    a[:date_end_planned] = d.attributes["iso-date"]
				  end
				end
			end

			# correct for dfid (leaves dates with 'Z' on the end)... think maybe this happens automatically??
			#a[:date_start_actual].chop!; a[:date_start_planned].chop!; a[:date_end_actual].chop!; a[:date_end_planned].chop! if @package.donors == 'dfid'

			a[:status_code] = activity.elements["activity-status"].attributes["code"] if activity.elements["activity-status"]
			a[:status] = activity.elements["activity-status"].text if activity.elements["activity-status"]
			a[:activity_website] = activity.elements["activity-website"].text if activity.elements["activity-website"]
			
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
				@thetext += "<p>Saved activity " + @activity.title + ".</p>"
			  else
				@thetext += "<p>Couldn't save activity <b>" + @activity.title + "</b>.</p>"
			  end
			
			if activity.elements["transaction"] 
				transactions = []
				activity.elements.each('transaction') do |t|
					# chop Z off date if it's DFID
					t.elements["transaction-date"].attributes["iso-date"].chop! if (t.elements["transaction-date"] and t.elements["transaction-date"].attributes["iso-date"] and @package.donors=='dfid')
					t.elements["value"].attributes["value-date"].chop! if t.elements["value"].attributes["value-date"] and @package.donors=='dfid'
					# make currency
					@transaction_currency = ''
					if t.elements["value"].attributes["currency"] 
					  @transaction_currency = t.elements["value"].attributes["currency"]
					elsif activity.attributes["default-currency"]
					  @transaction_currency = activity.attributes["default-currency"]
					end
					transactions << {
						:activity_id => (@activity.id),
						:value => (t.elements["value"].text if t.elements["value"].text),
						:value_date => (t.elements["value"].attributes["value-date"] if t.elements["value"].attributes["value-date"]),
						:value_currency => (@transaction_currency if @transaction_currency),
						:transaction_type => (t.elements["transaction-type"].text if t.elements["transaction-type"]),
						:transaction_type_code => (t.elements["transaction-type"].attributes["code"] if t.elements["transaction-type"] and t.elements["transaction-type"].attributes["code"]),
						:provider_org => (t.elements["provider-org"].text if t.elements["provider-org"]),
						:provider_org_ref => (t.elements["provider-org"].attributes["ref"] if t.elements["provider-org"]),
						:provider_org_type => (t.elements["provider-org"].attributes["type"] if t.elements["provider-org"]),

						:receiver_org => (t.elements["receiver-org"].text if t.elements["receiver-org"]),
						:receiver_org_ref => (t.elements["receiver-org"].attributes["ref"] if t.elements["receiver-org"]),
						:receiver_org_type => (t.elements["receiver-org"].attributes["type"] if t.elements["receiver-org"]),

						:description => (t.elements["description"].text if t.elements["description"]),

						:transaction_date => (t.elements["transaction-date"].text if t.elements["transaction-date"]),
						:transaction_date_iso => (t.elements["transaction-date"].attributes["iso-date"] if t.elements["transaction-date"]),

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

					  else
						@thetext += "<p>Couldn't save transaction in activity <b>" + @activity.title + "</b></p>"
					  end
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
				  else
					@thetext += "<p>Couldn't save sector in activity <b>" + @activity.title + "</b>.</p>"
				  end
				sector_activities[:sector_id] = @sector.id.to_s
				end

				sector_activities[:activity_id] = @activity.id.to_s

				@sector_activities = ActivitiesSector.new(sector_activities)

				  if @sector_activities.save
				  else
					@thetext += "<p>Couldn't save sector in activity <b>" + @activity.title + "</b>.</p>"
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
				  else
					@thetext += "<p>Couldn't save policy marker for activity <b>" + @activity.title + "</b>.</p>"
				  end
				policy_markers_activities[:policy_marker_id] = @pm.id.to_s
				end

				if policy_markers_activities[:significance] == '1'
					policy_markers_activities[:activity_id] = @activity.id.to_s
					@pma = ActivitiesPolicyMarker.new(policy_markers_activities)
					# only add relation if significance == '1'

					  if @pma.save
					  else
						@thetext += "<p>Couldn't save Policy Marker-Activity relation for activity <b>" + @activity.title + "</b>.</p>"
					  end
				end
			end
			related_activity.each do |ra|
				ra[:activity_id] = @activity.id.to_s
				@ra = RelatedActivity.new(ra)
				if @ra.save
				else
					@thetext += "<p>Couldn't add activity relation for activity <b>" + @activity.title + "</b>.</p>"
				end
			end

			organisations.each do |org|
				#find organisation by text... not ideal but normally no ref (except funding, extending) so not really an alternative
				theorg = Organisation.find_by_name(org[:name])
				# we've got name, ref, orgtype, reltype
				# Organisation => name, ref, orgtype
				# Activities_Organisations => @activity.id, @organisation.id reltype
				activities_organisations ={}

				# Requires an integer.. I'm making this up
				if org[:reltype] == 'Funding'
					activities_organisations[:rel_type] = 1
				elsif org[:reltype] == 'Extending'
					activities_organisations[:rel_type] = 2
				elsif org[:reltype] == 'Implementing'
					activities_organisations[:rel_type] = 3
				end

				org.delete(:reltype)

				if theorg
				activities_organisations[:organisation_id] = theorg.id.to_s
				# org already exists, just add reference in relationship table
				else
				# org doesn't exist, so create it.
				@organisation = Organisation.new(org)

				  if @organisation.save
				  else
					@thetext += "<p>Couldn't save organisation for activity <b>" + @activity.title + "</b>.</p>"
				  end
				activities_organisations[:organisation_id] = @organisation.id.to_s
				end

				
				activities_organisations[:activity_id] = @activity.id.to_s
				@orga = ActivitiesOrganisation.new(activities_organisations)

				  if @orga.save
				  else
					@thetext += "<p>Couldn't save Activity-Organisation relation for activity <b>" + @activity.title + "</b>.</p>"
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
    if params[:max]
        @max = params[:max].to_i
    else
    	@max = 5
    end
    @count = 0
    @catch_errors = 0
    @package_count = 0
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
		  newpackage[:tags] = package["tags"][0] if package["tags"][0]
		  newpackage[:groups_types] = package["groups_types"][0] if package["groups_types"][0] if package["groups_types"]
		  newpackage[:groups] = package["groups"][0] if package["groups"][0]
		  newpackage[:donors] = package["extras"]["donors"][0] if package["extras"]["donors"][0]
		  newpackage[:activity_period_from] = package["extras"]["activity_period-from"]
		  newpackage[:verified] = package["extras"]["verified"] if package["extras"]["verified"]
		  newpackage[:donors_type] = package["extras"]["donors_type"][0] if package["extras"]["donors_type"][0]
		  newpackage[:activity_count] = package["extras"]["activity_count"] if package["extras"]["activity_count"]
		  newpackage[:country] = package["extras"]["country"] if package["extras"]["country"]
		  newpackage[:donors_country] = package["extras"]["donors_country"][0] if package["extras"]["donors_country"]
		  newpackage[:activity_period_to] = package["extras"]["activity_period-to"] if package["extras"]["activity_period-to"]
		  newpackage[:revisionid] = package["revision_id"] if package["revision_id"]
		  newpackage.delete("revision_id")
		  newpackage[:licenseid] = package["license_id"] if package["license_id"]
		  newpackage.delete("license_id")
		  newpackage[:resourcesid] = package["resources"][0]["id"] if package["resources"][0]["id"]
		  resourcesid = newpackage[:resourcesid] if newpackage[:resourcesid]
		  newpackage[:iati_preview] = package["extras"]["iati:preview:"+resourcesid] if package["extras"]["iati:preview:"+resourcesid]
		  newpackage[:resources_packageid] = package["resources"][0]["package_id"] if package["resources"][0]["package_id"]
		  newpackage[:resources_url] = package["resources"][0]["url"] if package["resources"][0]["url"]
		  newpackage[:resources_format] = package["resources"][0]["format"] if package["resources"][0]["format"]
		  newpackage[:resources_description] = package["resources"][0]["description"] if package["resources"][0]["description"]
		  newpackage[:resources_hash] = package["resources"][0]["hash"] if package["resources"][0]["hash"]
		  newpackage[:resources_position] = package["resources"][0]["position"] if package["resources"][0]["position"]

		  newpackage.delete("relationships")
		  newpackage.delete("extras")
		  newpackage.delete("resources")
		  newpackage.delete("metadata-created")
		  
		  @package = Package.new(newpackage)

		  if @package.save
			@showpackages += "<font color=\"green\">Saved package.</font>"
			@package_count = @package_count +1
		  else
			@showpackages += "<font color=\"red\">Couldn't save package.</font>"
			@catcherrors = @catch_errors +1
		  end
	    end
        end
    end
 # finished getting each package
	if @catch_errors == 0
	@msg = @template.pluralize(@package_count, 'more package')
		respond_to do |format|
			format.html { redirect_to(packages_url, :notice => 'Found ' + @msg + '.') }
			format.xml  { head :ok }
		end
	end
		
  end
end
