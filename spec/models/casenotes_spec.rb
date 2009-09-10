require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Casenote do
  before(:each) do
    @valid_attributes = {
      :client => ,
      :note => "value for note"
    }
  end

  it "should create a new instance given valid attributes" do
    Casenote.create!(@valid_attributes)
  end
end
