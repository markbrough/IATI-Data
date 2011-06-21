class ActivitiesOrganisationController < ApplicationController
	def index
	    @activityorganisations = ActivitiesOrganisation.all

	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @implementing_organisation }
	    end
	end
end
