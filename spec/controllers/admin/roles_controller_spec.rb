require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::RolesController do

  def mock_role(stubs={})
    @mock_role ||= mock_model(Role, stubs)
  end

  before :each do
    do_authorize
    controller.stubs(:local_request?).returns(true)
  end

  describe "responding to GET index" do

    it "should expose all roles as @roles" do
      Role.stubs(:paginate).returns([mock_role])
      get :index
      assigns[:roles].should == [mock_role]
    end

  end

  describe "Inaccecible actions" do

    before(:each) {rescue_action_in_public!}

    it "should not respond to show action" do
      get :show
      response.status.should =~ /404/
    end

    it "should not respond to new action" do
      get :new
      response.status.should =~ /404/
    end

  end

#  describe "responding to GET edit" do

#    it "should expose the requested role as @role" do
#      Role.stubs(:find).with("37").returns(mock_role)
#      get :edit, :id => "37"
#      assigns[:role].should equal(mock_role)
#    end

#  end

#  describe "responding to POST create" do

#    describe "with valid params" do

#      it "should expose a newly created role as @role" do
#        Role.stubs(:new).with({'these' => 'params'}).returns(mock_role(:save => true))
#        post :create, :role => {:these => 'params'}
#        assigns(:role).should equal(mock_role)
#      end

#      it "should redirect to the created role" do
#        Role.stubs(:new).returns(mock_role(:save => true))
#        post :create, :role => {}
#        response.should redirect_to(role_url(mock_role))
#      end

#    end

#    describe "with invalid params" do

#      it "should expose a newly created but unsaved role as @role" do
#        Role.stubs(:new).with({'these' => 'params'}).returns(mock_role(:save => false))
#        post :create, :role => {:these => 'params'}
#        assigns(:role).should equal(mock_role)
#      end

#      it "should re-render the 'new' template" do
#        Role.stubs(:new).returns(mock_role(:save => false))
#        post :create, :role => {}
#        response.should render_template('new')
#      end

#    end

#  end

#  describe "responding to PUT udpate" do

#    describe "with valid params" do

#      it "should update the requested role" do
#        Role.stubs(:find).with("37").returns(mock_role)
#        mock_role.stubs(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :role => {:these => 'params'}
#      end

#      it "should expose the requested role as @role" do
#        Role.stubs(:find).returns(mock_role(:update_attributes => true))
#        put :update, :id => "1"
#        assigns(:role).should equal(mock_role)
#      end

#      it "should redirect to the role" do
#        Role.stubs(:find).returns(mock_role(:update_attributes => true))
#        put :update, :id => "1"
#        response.should redirect_to(role_url(mock_role))
#      end

#    end

#    describe "with invalid params" do

#      it "should update the requested role" do
#        Role.stubs(:find).with("37").returns(mock_role)
#        mock_role.stubs(:update_attributes).with({'these' => 'params'})
#        put :update, :id => "37", :role => {:these => 'params'}
#      end

#      it "should expose the role as @role" do
#        Role.stubs(:find).returns(mock_role(:update_attributes => false))
#        put :update, :id => "1"
#        assigns(:role).should equal(mock_role)
#      end

#      it "should re-render the 'edit' template" do
#        Role.stubs(:find).returns(mock_role(:update_attributes => false))
#        put :update, :id => "1"
#        response.should render_template('edit')
#      end

#    end

#  end

#  describe "responding to DELETE destroy" do

#    it "should not destroy the requested role" do
#      delete :destroy, :id => "37"
#      response.should be_not_found
#    end

#    it "should redirect to the roles list" do
#      delete :destroy, :id => "1"
#      response.should be_not_found
#    end

#  end

end

