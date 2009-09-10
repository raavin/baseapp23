require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/casenotes/index.html.erb" do
  include ClientHelper

  before(:each) do
    assigns[:controller].stubs(:authorized?).returns(true)
    assigns[:casenotes] = [
      stub_model(Casenote,
        :client => ,
        :note => "value for note"
      ),
      stub_model(Casenote,
        :client => ,
        :note => "value for note"
      )
    ]
    assigns[:casenotes].stubs(:page_count).returns(1)
  end

  it "renders a list of casenotes" do
    render
    response.should have_tag("tr>td", .to_s, 2)
    response.should have_tag("tr>td", "value for note".to_s, 2)
  end
end

