class OrganisationsController < ApplicationController
	def index
	   @limit = 200.to_f
	    if params[:page]
	      @page = params[:page]
	      @page = @page.to_f
	      @page = @page -1
	    else
	      @page = 0
	    end
	    pagemultiplier = @limit * @page
	    @organisations = Organisation.find(:all, :order=>"name", :limit=>@limit, :offset=>pagemultiplier)


	    # get total number of rows
	    @totalrows = Organisation.count.to_f
	    @numpages = (@totalrows / @limit)
	    @pagination = []
		for i in 1..@numpages
		  @pagination << {
			:page => i.to_s
			}
		end
	
		if ((@numpages.to_f - i.to_f) > 0) and i
			@pagination << {
				:page => (i+1).to_s
			}
		end



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
