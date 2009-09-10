class CasenotesController < ApplicationController
  # GET /casenotes
  # GET /casenotes.xml
  
  def all
    @client = Client.find :all
    @casenotes = Casenote.paginate(:page => params[:page], :per_page => 10)
  end
  
  def index
    @client = Client.find(params[:client_id])
    @casenotes = @client.casenotes.paginate

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @casenotes }
    end
  end

  # GET /casenotes/1
  # GET /casenotes/1.xml
  def show
    @client = Client.find(params[:client_id])
    @casenote = @client.casenotes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @casenote }
    end
  end

  # GET /casenotes/new
  # GET /casenotes/new.xml
  def new
    @client = Client.find(params[:client_id])
    @casenote = @client.casenotes.build
    @user = User.find :all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @casenote }
    end
  end

  # GET /casenotes/1/edit
  def edit
    @client = Client.find(params[:client_id])
    @casenote = @client.casenotes.find(params[:id])
  end

  # POST /casenotes
  # POST /casenotes.xml
  def create
    @client = Client.find(params[:client_id])
    @casenote = @client.casenotes.build(params[:casenote])
    @user = User.find :all
    respond_to do |format|
      if @casenote.save
        flash[:notice] = 'Casenote was successfully created.'
        format.html { redirect_to(@client, @casenote) }
        format.xml  { render :xml => @casenote, :status => :created, :location => @casenote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @casenote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /casenotes/1
  # PUT /casenotes/1.xml
  def update
    @client = Client.find(params[:client_id])
    @casenote = Casenote.find(params[:id])

    respond_to do |format|
      if @casenote.update_attributes(params[:casenote])
        flash[:notice] = 'Casenote was successfully updated.'
        format.html { redirect_to(@client, @casenote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @casenote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /casenotes/1
  # DELETE /casenotes/1.xml
  def destroy
    @client = Client.find(params[:client_id])
    @casenote = Casenote.find(params[:id])
    @casenote.destroy

    respond_to do |format|
      format.html { redirect_to client_casenotes_path(@client) }
      format.xml  { head :ok }
    end
  end
end

# table_name:                              casenotes
# file_name:                               casenote
# class_name:                              Casenote
# parent_controller_name:                  Casenotes
# controller_name:                         Clients                
# controller_class_name:                   Client
# controller_singular_name:                client
# controller_plural_name:                  clients

# ./script/generate authenticated FoonParent::Foon SporkParent::Spork -p --force --rspec --dump-generator-attrs
# table_name:                              casenotes
# file_name:                               casenote
# class_name:                              Casenote
# class_path                                
# controller_file_name                     clients 
# controller_name:                         Clients
# controller_class_path:                   
# controller_file_path:                    clients
# controller_class_nesting:                
# controller_class_nesting_depth:          0
# controller_class_name:                   Client
# controller_singular_name:                client
# controller_plural_name:                  
# controller_routing_name:                 client
# controller_routing_path:                 client
# controller_controller_name:              
# controller_file_name:                    clients
# controller_table_name:                   
# controller_plural_name:                  
# parent_controller_name:                   Casenotes
# parent_controller_class_path:             
# parent_controller_file_path:              casenotes
# parent_controller_class_nesting:          
# parent_controller_class_nesting_depth:    0
# parent_controller_class_name:             Casenotes
# parent_controller_singular_name:          casenotes
# parent_controller_plural_name:            
# parent_controller_routing_name:           casenotes
# parent_controller_routing_path:           casenotes
# parent_controller_controller_name:        
# parent_controller_file_name:              casenotes
# parent_controller_singular_name:          casenotes
# parent_controller_table_name:             
# parent_controller_plural_name:            