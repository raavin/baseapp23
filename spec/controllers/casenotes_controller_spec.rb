require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClientController do

  before(:each) do
    do_authorize
  end

  def mock_casenote(stubs={})
    @mock_casenote ||= mock_model(Casenote, stubs)
  end

  describe "GET index" do
    it "assigns all casenotes as @casenotes" do
      expects_paginate(Casenote, paginate_results(mock_casenote))
      get :index
      assigns[:casenotes].should == [mock_casenote]
    end
  end

  describe "GET show" do
    it "assigns the requested casenote as @casenote" do
      Casenote.expects(:find).with("37").returns(mock_casenote)
      get :show, :id => "37"
      assigns[:casenote].should equal(mock_casenote)
    end
  end

  describe "GET new" do
    it "assigns a new casenote as @casenote" do
      Casenote.expects(:new).returns(mock_casenote)
      get :new
      assigns[:casenote].should equal(mock_casenote)
    end
  end

  describe "GET edit" do
    it "assigns the requested casenote as @casenote" do
      Casenote.expects(:find).with("37").returns(mock_casenote)
      get :edit, :id => "37"
      assigns[:casenote].should equal(mock_casenote)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created casenote as @casenote" do
        Casenote.expects(:new).with({'these' => 'params'}).returns(mock_casenote(:save => true))
        post :create, :casenote => {:these => 'params'}
        assigns(:casenote).should equal(mock_casenote)
      end

      it "redirects to the created casenote" do
        Casenote.stubs(:new).returns(mock_casenote(:save => true))
        post :create, :casenote => {}
        response.should redirect_to(casenote_url(mock_casenote))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved casenote as @casenote" do
        Casenote.stubs(:new).with({'these' => 'params'}).returns(mock_casenote(:save => false))
        post :create, :casenote => {:these => 'params'}
        assigns[:casenote].should equal(mock_casenote)
      end

      it "re-renders the 'new' template" do
        Casenote.stubs(:new).returns(mock_casenote(:save => false))
        post :create, :casenote => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested casenote" do
        Casenote.expects(:find).with("37").returns(mock_casenote)
        mock_casenote.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :casenote => {:these => 'params'}
      end

      it "assigns the requested casenote as @casenote" do
        Casenote.stubs(:find).returns(mock_casenote(:update_attributes => true))
        put :update, :id => "1"
        assigns(:casenote).should equal(mock_casenote)
      end

      it "redirects to the casenote" do
        Casenote.stubs(:find).returns(mock_casenote(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(casenote_url(mock_casenote))
      end
    end

    describe "with invalid params" do
      it "updates the requested casenote" do
        Casenote.expects(:find).with("37").returns(mock_casenote)
        mock_casenote.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :casenote => {:these => 'params'}
      end

      it "assigns the casenote as @casenote" do
        Casenote.stubs(:find).returns(mock_casenote(:update_attributes => false))
        put :update, :id => "1"
        assigns(:casenote).should equal(mock_casenote)
      end

      it "re-renders the 'edit' template" do
        Casenote.stubs(:find).returns(mock_casenote(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested casenote" do
      Casenote.expects(:find).with("37").returns(mock_casenote)
      mock_casenote.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the casenotes list" do
      Casenote.stubs(:find).returns(mock_casenote(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(casenotes_url)
    end
  end

end

