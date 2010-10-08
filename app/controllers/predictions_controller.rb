class PredictionsController < ApplicationController

  before_filter :authenticate, :only => [ :index, :destroy ]

  def index
    @predictions = Prediction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @predictions }
    end
  end

  def show
    if @prediction = Prediction.find_by_uuid(params[:id])

      respond_to do |format|
        format.html
      end
    else
      redirect_to "/nabal"
    end
  end

  def new
    @prediction = Prediction.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @prediction         = Prediction.new(params[:prediction])
    @prediction.mode    = params[:mode]
    @prediction.uuid    = UUIDTools::UUID.timestamp_create.to_s
    @prediction.status  = "Standing by"

    respond_to do |format|
      if @prediction.save
        Delayed::Job.enqueue PredictionJob.new(@prediction.id)
        format.html { redirect_to(prediction_url(@prediction.uuid), :notice => 'Your job was successfully submitted.') }
      else
        format.html { render :action => 'new' }
      end
    end
  end

  def destroy
    @prediction = Prediction.find_by_uuid(params[:id])
    @prediction.destroy

    respond_to do |format|
      format.html { redirect_to(predictions_url) }
      format.xml  { head :ok }
    end
  end


  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      Digest::SHA1.hexdigest(username) == '5066c66660935498a6bf88cd4aa69a1aa39226fa' &&
        Digest::SHA1.hexdigest(password) == '68d033e4612755c317d9882dbec5d4a480f2dd60'
    end
  end
end
