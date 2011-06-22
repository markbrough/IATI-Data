class AggregationsController < ApplicationController
  # GET /aggregations
  # GET /aggregations.xml
  def index
    @aggregations = Aggregation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aggregations }
      format.json { render :json => @aggregations }
    end
  end

  # GET /aggregations/1
  # GET /aggregations/1.xml
  def show
    @aggregation = Aggregation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aggregation }
    end
  end

  # GET /aggregations/new
  # GET /aggregations/new.xml
  def new
    @aggregation = Aggregation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aggregation }
    end
  end

  # GET /aggregations/1/edit
  def edit
    @aggregation = Aggregation.find(params[:id])
  end

  # POST /aggregations
  # POST /aggregations.xml
  def create

    @thecontroller = params[:aggregation][:thecontroller]

    @thecountries = Countryregion.find(:all)
    @thecountries.each do |country|
	@thevalue = 0
	country.activities.each do |activity|
		@thevalue = @thevalue + activity.transactions.sum(:value)
	end
	aggregation = {}
	aggregation[:name] = country.country_name
	aggregation[:value] = @thevalue
	aggregation[:contribs] = country.activities.count
	aggregation[:thecontroller] = "Countries"
	aggregation[:theid] = country.id
	aggregation[:group] = 'countries'
	if (aggregation[:value] > 0)
		@aggregation = Aggregation.new(aggregation)
		@aggregation.save
	end
    end

   # @aggregation = Aggregation.new(params[:aggregation])

    respond_to do |format|
      if @aggregation.save
        format.html { redirect_to(@aggregation, :notice => 'Aggregation was successfully created.') }
        format.xml  { render :xml => @aggregation, :status => :created, :location => @aggregation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aggregation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aggregations/1
  # PUT /aggregations/1.xml
  def update
    @aggregation = Aggregation.find(params[:id])

    respond_to do |format|
      if @aggregation.update_attributes(params[:aggregation])
        format.html { redirect_to(@aggregation, :notice => 'Aggregation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aggregation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aggregations/1
  # DELETE /aggregations/1.xml
  def destroy
# Destroy all aggregations, not just one
    @aggregations = Aggregation.all
	@aggregations.each do |aggregation|
		aggregation.destroy
	end
#    @aggregation = Aggregation.find(params[:id])
 #   @aggregation.destroy

    respond_to do |format|
      format.html { redirect_to(aggregations_url) }
      format.xml  { head :ok }
    end
  end
end
