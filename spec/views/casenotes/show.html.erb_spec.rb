require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/casenotes/show.html.erb" do
  include ClientHelper
  before(:each) do
    assigns[:casenote] = @casenote = stub_model(Casenote,
      :client => ,
      :note => "value for note"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(//)
    response.should have_text(/value\ for\ note/)
  end
end

