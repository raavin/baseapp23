require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClientsController do

  before(:each) do
    do_authorize
  end

  def mock_client(stubs={})
    @mock_client ||= mock_model(Client, stubs)
  end

  describe "GET index" do
    it "assigns all clients as @clients" do
      expects_paginate(Client, paginate_results(mock_client))
      get :index
      assigns[:clients].should == [mock_client]
    end
  end

  describe "GET show" do
    it "assigns the requested client as @client" do
      Client.expects(:find).with("37").returns(mock_client)
      get :show, :id => "37"
      assigns[:client].should equal(mock_client)
    end
  end

  describe "GET new" do
    it "assigns a new client as @client" do
      Client.expects(:new).returns(mock_client)
      get :new
      assigns[:client].should equal(mock_client)
    end
  end

  describe "GET edit" do
    it "assigns the requested client as @client" do
      Client.expects(:find).with("37").returns(mock_client)
      get :edit, :id => "37"
      assigns[:client].should equal(mock_client)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created client as @client" do
        Client.expects(:new).with({'these' => 'params'}).returns(mock_client(:save => true))
        post :create, :client => {:these => 'params'}
        assigns(:client).should equal(mock_client)
      end

      it "redirects to the created client" do
        Client.stubs(:new).returns(mock_client(:save => true))
        post :create, :client => {}
        response.should redirect_to(client_url(mock_client))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved client as @client" do
        Client.stubs(:new).with({'these' => 'params'}).returns(mock_client(:save => false))
        post :create, :client => {:these => 'params'}
        assigns[:client].should equal(mock_client)
      end

      it "re-renders the 'new' template" do
        Client.stubs(:new).returns(mock_client(:save => false))
        post :create, :client => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested client" do
        Client.expects(:find).with("37").returns(mock_client)
        mock_client.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :client => {:these => 'params'}
      end

      it "assigns the requested client as @client" do
        Client.stubs(:find).returns(mock_client(:update_attributes => true))
        put :update, :id => "1"
        assigns(:client).should equal(mock_client)
      end

      it "redirects to the client" do
        Client.stubs(:find).returns(mock_client(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(client_url(mock_client))
      end
    end

    describe "with invalid params" do
      it "updates the requested client" do
        Client.expects(:find).with("37").returns(mock_client)
        mock_client.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :client => {:these => 'params'}
      end

      it "assigns the client as @client" do
        Client.stubs(:find).returns(mock_client(:update_attributes => false))
        put :update, :id => "1"
        assigns(:client).should equal(mock_client)
      end

      it "re-renders the 'edit' template" do
        Client.stubs(:find).returns(mock_client(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested client" do
      Client.expects(:find).with("37").returns(mock_client)
      mock_client.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the clients list" do
      Client.stubs(:find).returns(mock_client(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(clients_url)
    end
  end

end

