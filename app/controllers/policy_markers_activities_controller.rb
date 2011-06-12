class PolicyMarkersActivitiesController < ApplicationController
  # GET /policy_markers_activities
  # GET /policy_markers_activities.xml
  def index
    @policy_markers_activities = PolicyMarkersActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @policy_markers_activities }
    end
  end

  # GET /policy_markers_activities/1
  # GET /policy_markers_activities/1.xml
  def show
    @policy_markers_activity = PolicyMarkersActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @policy_markers_activity }
    end
  end

  # GET /policy_markers_activities/new
  # GET /policy_markers_activities/new.xml
  def new
    @policy_markers_activity = PolicyMarkersActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @policy_markers_activity }
    end
  end

  # GET /policy_markers_activities/1/edit
  def edit
    @policy_markers_activity = PolicyMarkersActivity.find(params[:id])
  end

  # POST /policy_markers_activities
  # POST /policy_markers_activities.xml
  def create
    @policy_markers_activity = PolicyMarkersActivity.new(params[:policy_markers_activity])

    respond_to do |format|
      if @policy_markers_activity.save
        format.html { redirect_to(@policy_markers_activity, :notice => 'PolicyMarkersActivity was successfully created.') }
        format.xml  { render :xml => @policy_markers_activity, :status => :created, :location => @policy_markers_activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @policy_markers_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /policy_markers_activities/1
  # PUT /policy_markers_activities/1.xml
  def update
    @policy_markers_activity = PolicyMarkersActivity.find(params[:id])

    respond_to do |format|
      if @policy_markers_activity.update_attributes(params[:policy_markers_activity])
        format.html { redirect_to(@policy_markers_activity, :notice => 'PolicyMarkersActivity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @policy_markers_activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /policy_markers_activities/1
  # DELETE /policy_markers_activities/1.xml
  def destroy
    @policy_markers_activity = PolicyMarkersActivity.find(params[:id])
    @policy_markers_activity.destroy

    respond_to do |format|
      format.html { redirect_to(policy_markers_activities_url) }
      format.xml  { head :ok }
    end
  end
end
