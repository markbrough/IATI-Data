class ActivitiesSectorController < ApplicationController
  # GET /activities_sectors
  # GET /activities_sectors.xml
  def index
    @activities_sectors = ActivitiesSector.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities_sectors }
    end
  end

  # GET /activities_sectors/1
  # GET /activities_sectors/1.xml
  def show
    @activities_sector = ActivitiesSector.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activities_sector }
    end
  end

  # GET /activities_sectors/new
  # GET /activities_sectors/new.xml
  def new
    @activities_sector = ActivitiesSector.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activities_sector }
    end
  end

  # GET /activities_sectors/1/edit
  def edit
    @activities_sector = ActivitiesSector.find(params[:id])
  end

  # POST /activities_sectors
  # POST /activities_sectors.xml
  def create
    @activities_sector = ActivitiesSector.new(params[:activities_sector])

    respond_to do |format|
      if @activities_sector.save
        format.html { redirect_to(@activities_sector, :notice => 'ActivitiesSector was successfully created.') }
        format.xml  { render :xml => @activities_sector, :status => :created, :location => @activities_sector }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activities_sector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities_sectors/1
  # PUT /activities_sectors/1.xml
  def update
    @activities_sector = ActivitiesSector.find(params[:id])

    respond_to do |format|
      if @activities_sector.update_attributes(params[:activities_sector])
        format.html { redirect_to(@activities_sector, :notice => 'ActivitiesSector was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activities_sector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities_sectors/1
  # DELETE /activities_sectors/1.xml
  def destroy
    @activities_sector = ActivitiesSector.find(params[:id])
    @activities_sector.destroy

    respond_to do |format|
      format.html { redirect_to(activities_sectors_url) }
      format.xml  { head :ok }
    end
  end
end
