class ActivitiesController < ApplicationController
  # GET /activities
  # GET /activities.xml
  def index

    @limit = 10.to_f
    if params[:page]
      @page = params[:page]
      @page = @page.to_f
      @page = @page -1
    else
      @page = 0
    end
    pagemultiplier = @limit * @page
    @conditions = {}
    @conditions[:hierarchy] = '1' unless !(params[:implementing_org].blank? and params[:recipient_country].blank? and params[:iati_identifier].blank? and params[:recipient_region].blank?)
    @conditions[:implementing_org] = params[:implementing_org] unless params[:implementing_org].blank?
    @conditions[:recipient_country] = params[:recipient_country] unless params[:recipient_country].blank?
    @conditions[:recipient_region] = params[:recipient_region] unless params[:recipient_region].blank?
    @conditions[:iati_identifier] = params[:iati_identifier] unless params[:iati_identifier].blank?
    if @conditions[:recipient_country]
	@conditions.delete(:hierarchy)
    end
    if params[:sector]
      sector_conditions = {}
      sector_conditions[:sector_id] = params[:sector]
      @sector=SectorsActivity.find(:all, :conditions=>sector_conditions)
      @conditions[:id] = @sector
    end
    @activities = Activity.find(:all, :conditions=> @conditions, :limit => @limit, :offset=>pagemultiplier)
    # get total number of rows
    @totalrows = Activity.find(:all, :conditions=>@conditions).count.to_f
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
      format.xml  { render :xml => @activities }
    end
  end

  # GET /activities/1
  # GET /activities/1.xml
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end

  # POST /activities
  # POST /activities.xml
  def create
    @activity = Activity.new(params[:activity])

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(@activity, :notice => 'Activity was successfully created.') }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(@activity, :notice => 'Activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end
end
