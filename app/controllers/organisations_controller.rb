class OrganisationsController < ApplicationController
	def index
	    @organisations = Organisation.find(:all, :order=>"name")

	    respond_to do |format|
	      format.html # index.html.erb
	      format.xml  { render :xml => @implementing_organisation }
	    end
	end
	  # GET /activities/1
	  # GET /activities/1.xml
	  def show
	    @organisation = Organisation.find(params[:id])
	    respond_to do |format|
	      format.html # show.html.erb
	      format.xml  { render :xml => @organisation }
	    end
	  end

end
