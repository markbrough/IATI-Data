class CountryregionsController < ApplicationController
	   def csv_import 
		require 'csv'
		require 'pp'
		@message = ''
		input = File.open("public/countriesregions.csv")
		input.each { |line|    
#		    elements = CSV::parse_line(line, ';')
		    elements = CSV.parse(line)
		    if elements.size == 0
			@message += "Error on row: " + line + "<br />"
		
		    elsif elements[0].nil?
			# skip
		    elsif elements[0] == 'country_name'
			# skip
		    else
			c=Countryregion.new
			c.country_name=elements[0]
			c.dac_country_code=elements[1]
			c.iso2=elements[2]
			c.iso3=elements[3]
			c.dac_region_code=elements[4]
			c.dac_region_name=elements[5]
			c.item_type=elements[6]
			c.latitude=elements[7]
			c.longitude=elements[8]
			c.save
		    end

		}

	   end
	
	def csv_export

		@countryregions = Countryregion.find(:all)
	
		csv_string = FasterCSV.generate do |csv|

		#header row
		csv << ["country_name", "dac_country_code", "iso2", "iso3", "dac_region_name", "dac_region_code", "item_type", "latitude", "longitude"]

		#data rows
		@countryregions.each do |c|
			csv << [c.country_name, c.dac_country_code, c.iso2, c.iso3, c.dac_region_code, c.dac_region_name, c.item_type, c.latitude, c.longitude]
		end
		end

		send_data csv_string,
			:type =>'text/csv; charset=iso-8859-1; header=present',
			:diposition=> "attachment; filename=countryregions.csv"

	end


	def index
	@countryregions = Countryregion.find(:all, :order=>'ISO2')
	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @countryregions }
	    end
	end

	  # GET /activities/1
	  # GET /activities/1.xml
	  def show
	    @countryregion = Countryregion.find(params[:id])
	    respond_to do |format|
	      format.html # show.html.erb
	      format.xml  { render :xml => @countryregions }
	    end
	  end

end
