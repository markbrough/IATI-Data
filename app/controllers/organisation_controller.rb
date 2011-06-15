class OrganisationController < ApplicationController
	def index
	    @implementing_organisations = Activity.all(:select => 'distinct(implementing_org)')

	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @implementing_organisation }
	    end
	end
end
