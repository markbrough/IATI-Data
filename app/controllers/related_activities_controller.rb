class RelatedActivitiesController < ApplicationController
  # GET /related_activities
  # GET /related_activities.xml
  def index
    @related_activities = RelatedActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @related_activities }
    end
  end

  # GET /related_activities/1
  # GET /related_activities/1.xml
  def show
    @related_activity = RelatedActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @related_activity }
    end
  end

  # GET /related_activities/new
  # GET /related_activities/new.xml
  def new
    @related_activity = RelatedActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @related_activity }
    end
  end

  # GET /related_activities/1/edit
  def edit
    @related_activity = RelatedActivity.find(params[:id])
  end

  # POST /related_activities
  # POST /related_activities.xml
  def create
    @related_activity = RelatedActivity.new(params[:related_activity])

    respond_to do |format|
      if @related_activity.save
        format.html { redirect_to(@related_activity, :notice => 'RelatedActivity was successfully created.') }
        format.xml  { render :xml => @related_activity, :status => :created, :location => @related_activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @related_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /related_activities/1
  # PUT /related_activities/1.xml
  def update
    @related_activity = RelatedActivity.find(params[:id])

    respond_to do |format|
      if @related_activity.update_attributes(params[:related_activity])
        format.html { redirect_to(@related_activity, :notice => 'RelatedActivity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @related_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /related_activities/1
  # DELETE /related_activities/1.xml
  def destroy
    @related_activity = RelatedActivity.find(params[:id])
    @related_activity.destroy

    respond_to do |format|
      format.html { redirect_to(related_activities_url) }
      format.xml  { head :ok }
    end
  end
end
