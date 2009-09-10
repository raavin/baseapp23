require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/clients/index.html.erb" do
  include ClientsHelper

  before(:each) do
    assigns[:controller].stubs(:authorized?).returns(true)
    assigns[:clients] = [
      stub_model(Client,
        :name => "value for name"
      ),
      stub_model(Client,
        :name => "value for name"
      )
    ]
    assigns[:clients].stubs(:page_count).returns(1)
  end

  it "renders a list of clients" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
end

