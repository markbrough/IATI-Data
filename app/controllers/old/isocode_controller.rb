class IsocodeController < ApplicationController
   def csv_import 


	require 'csv'
	require 'pp'
	@message = ''
	input = File.open("public/isolonglat.csv")
	input.each { |line|    
	    elements = CSV::parse_line(line, ';')
	    if elements.size == 0
		@message += "Error on row: " + line + "<br />"
		
	    elsif elements[0].nil?
		# skip
	    else
		c=Isocode.new
		c.country=elements[0]
		c.latitude=elements[1]
		c.longitude=elements[2]
		c.save
	    end

	}

   end

	def index
	@isocodes = Isocode.find(:all)
		@isocodes.each do |isocode|
			if isocode.country != 'country'
				isocode.country
				isocode.longitude
				isocode.latitude
				params = {}
				params[:longitude] = isocode.longitude
				params[:latitude] = isocode.latitude
				params[:iso2] = isocode.country
				if @countryregion = Countryregion.find_by_iso2(isocode.country)
				   @countryregion.update_attributes(params)
				else
				   @countryregion = Countryregion.new(params)
				   @countryregion.save
				end
			end
		end

	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @isocodes }
	    end
	end

end
