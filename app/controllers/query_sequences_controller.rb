class QuerySequencesController < ApplicationController
  # GET /query_sequences
  # GET /query_sequences.xml
  def index
    @query_sequences = QuerySequence.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @query_sequences }
    end
  end

  # GET /query_sequences/1
  # GET /query_sequences/1.xml
  def show
    @query_sequence = QuerySequence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @query_sequence }
    end
  end

  # GET /query_sequences/new
  # GET /query_sequences/new.xml
  def new
    @query_sequence = QuerySequence.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @query_sequence }
    end
  end

  # GET /query_sequences/1/edit
  def edit
    @query_sequence = QuerySequence.find(params[:id])
  end

  # POST /query_sequences
  # POST /query_sequences.xml
  def create
    @query_sequence = QuerySequence.new(params[:query_sequence])

    respond_to do |format|
      if @query_sequence.save
        format.html { redirect_to(@query_sequence, :notice => 'Query sequence was successfully created.') }
        format.xml  { render :xml => @query_sequence, :status => :created, :location => @query_sequence }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @query_sequence.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /query_sequences/1
  # PUT /query_sequences/1.xml
  def update
    @query_sequence = QuerySequence.find(params[:id])

    respond_to do |format|
      if @query_sequence.update_attributes(params[:query_sequence])
        format.html { redirect_to(@query_sequence, :notice => 'Query sequence was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @query_sequence.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /query_sequences/1
  # DELETE /query_sequences/1.xml
  def destroy
    @query_sequence = QuerySequence.find(params[:id])
    @query_sequence.destroy

    respond_to do |format|
      format.html { redirect_to(query_sequences_url) }
      format.xml  { head :ok }
    end
  end
end
