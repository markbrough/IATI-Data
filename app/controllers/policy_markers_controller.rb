class PolicyMarkersController < ApplicationController
  # GET /policy_markers
  # GET /policy_markers.xml
  def index
    @policy_markers = PolicyMarker.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @policy_markers }
    end
  end

  # GET /policy_markers/1
  # GET /policy_markers/1.xml
  def show
    @policy_marker = PolicyMarker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @policy_marker }
    end
  end

  # GET /policy_markers/new
  # GET /policy_markers/new.xml
  def new
    @policy_marker = PolicyMarker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @policy_marker }
    end
  end

  # GET /policy_markers/1/edit
  def edit
    @policy_marker = PolicyMarker.find(params[:id])
  end

  # POST /policy_markers
  # POST /policy_markers.xml
  def create
    @policy_marker = PolicyMarker.new(params[:policy_marker])

    respond_to do |format|
      if @policy_marker.save
        format.html { redirect_to(@policy_marker, :notice => 'PolicyMarker was successfully created.') }
        format.xml  { render :xml => @policy_marker, :status => :created, :location => @policy_marker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @policy_marker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /policy_markers/1
  # PUT /policy_markers/1.xml
  def update
    @policy_marker = PolicyMarker.find(params[:id])

    respond_to do |format|
      if @policy_marker.update_attributes(params[:policy_marker])
        format.html { redirect_to(@policy_marker, :notice => 'PolicyMarker was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @policy_marker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /policy_markers/1
  # DELETE /policy_markers/1.xml
  def destroy
    @policy_marker = PolicyMarker.find(params[:id])
    @policy_marker.destroy

    respond_to do |format|
      format.html { redirect_to(policy_markers_url) }
      format.xml  { head :ok }
    end
  end
end
