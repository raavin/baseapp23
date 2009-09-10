require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClientController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "casenotes", :action => "index").should == "/casenotes"
    end

    it "maps #new" do
      route_for(:controller => "casenotes", :action => "new").should == "/casenotes/new"
    end

    it "maps #show" do
      route_for(:controller => "casenotes", :action => "show", :id => "1").should == "/casenotes/1"
    end

    it "maps #edit" do
      route_for(:controller => "casenotes", :action => "edit", :id => "1").should == "/casenotes/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "casenotes", :action => "create").should == {:path => "/casenotes", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "casenotes", :action => "update", :id => "1").should == {:path =>"/casenotes/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "casenotes", :action => "destroy", :id => "1").should == {:path =>"/casenotes/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/casenotes").should == {:controller => "casenotes", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/casenotes/new").should == {:controller => "casenotes", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/casenotes").should == {:controller => "casenotes", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/casenotes/1").should == {:controller => "casenotes", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/casenotes/1/edit").should == {:controller => "casenotes", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/casenotes/1").should == {:controller => "casenotes", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/casenotes/1").should == {:controller => "casenotes", :action => "destroy", :id => "1"}
    end
  end
end

