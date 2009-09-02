class <%= controller_class_name %>Controller < ApplicationController
  # GET /<%= table_name %>
  # GET /<%= table_name %>.xml
  def index
    @client = <%= parent_controller_class_name %>.find(params[:client_id])
    @<%= table_name %> = @client.<%= table_name %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= table_name %> }
    end
  end

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @client = Client.find(params[:client_id])
    @<%= file_name %> = @client.<%= table_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /casenotes/new
  # GET /casenotes/new.xml
  def new
    @client = Client.find(params[:client_id])
    @<%= file_name %> = @client.<%= table_name %>.build
    @user = User.find :all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /casenotes/1/edit
  def edit
    @client = Client.find(params[:client_id])
    @<%= file_name %> = @client.<%= table_name %>.find(params[:id])
  end

  # POST /casenotes
  # POST /casenotes.xml
  def create
    @client = Client.find(params[:client_id])
    @<%= file_name %> = @client.<%= table_name %>.build(params[:<%= file_name %>])
    #@user = User.find :all
    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to(@client, @<%= file_name %>) }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @client = Client.find(params[:client_id])
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to(@client, @<%= file_name %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @client = Client.find(params[:client_id])
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to client_<%= table_name %>_path(@client) }
      format.xml  { head :ok }
    end
  end
end
