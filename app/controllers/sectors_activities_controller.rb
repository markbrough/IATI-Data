class SectorsActivitiesController < ApplicationController
  # GET /sectors_activities
  # GET /sectors_activities.xml
  def index
    @sectors_activities = SectorsActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sectors_activities }
    end
  end

  # GET /sectors_activities/1
  # GET /sectors_activities/1.xml
  def show
    @sectors_activity = SectorsActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sectors_activity }
    end
  end

  # GET /sectors_activities/new
  # GET /sectors_activities/new.xml
  def new
    @sectors_activity = SectorsActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sectors_activity }
    end
  end

  # GET /sectors_activities/1/edit
  def edit
    @sectors_activity = SectorsActivity.find(params[:id])
  end

  # POST /sectors_activities
  # POST /sectors_activities.xml
  def create
    @sectors_activity = SectorsActivity.new(params[:sectors_activity])

    respond_to do |format|
      if @sectors_activity.save
        format.html { redirect_to(@sectors_activity, :notice => 'SectorsActivity was successfully created.') }
        format.xml  { render :xml => @sectors_activity, :status => :created, :location => @sectors_activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sectors_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sectors_activities/1
  # PUT /sectors_activities/1.xml
  def update
    @sectors_activity = SectorsActivity.find(params[:id])

    respond_to do |format|
      if @sectors_activity.update_attributes(params[:sectors_activity])
        format.html { redirect_to(@sectors_activity, :notice => 'SectorsActivity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sectors_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sectors_activities/1
  # DELETE /sectors_activities/1.xml
  def destroy
    @sectors_activity = SectorsActivity.find(params[:id])
    @sectors_activity.destroy

    respond_to do |format|
      format.html { redirect_to(sectors_activities_url) }
      format.xml  { head :ok }
    end
  end
end
