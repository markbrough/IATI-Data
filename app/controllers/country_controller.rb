class CountryController < ApplicationController
	def index
	    @countries = Activity.all(:select => 'distinct(recipient_country), recipient_country_code')

	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @countries }
	    end
	end
end
