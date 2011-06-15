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


#     @parsed_file=CSV::Reader.parse(params[:dump][:file])
#     n=0
#     @parsed_file.each do |row|
#	     c=Isocode.new
#	     c.country=row[1]
#	     c.latitude=row[2]
#	     c.longitude=row[3]
#		     if c.save
#			n=n+1
#			GC.start if n%50==0
#		     end
#	     flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
 #    end
   end

	def index
	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @isocodes }
	    end
	end

end
