class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.xml

  before_filter :get_activity
  # :get_activity is defined at the bottom of the file,
  # and takes the activity_id given by the routing and 
  # converts it into an @activity object.

  def index
    @transactions = @activity.transactions

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = @activity.transactions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = @activity.transactions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = @activity.transactions.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = @activity.transactions.build(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to([@activity, @transaction], :notice => 'Transaction was successfully created.') }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = @activity.transactions.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to([@activity, @transaction], :notice => 'Transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = @activity.transactions.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(activity_transactions_path(@activity)) }
      format.xml  { head :ok }
    end
  end

private
  def get_activity
    @activity = Activity.find(params[:activity_id])
  end
end
