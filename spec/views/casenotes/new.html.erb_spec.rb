require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/casenotes/new.html.erb" do
  include ClientHelper

  before(:each) do
    assigns[:casenote] = stub_model(Casenote,
      :new_record? => true,
      :client => ,
      :note => "value for note"
    )
  end

  it "renders new casenote form" do
    render

    response.should have_tag("form[action=?][method=post]", casenotes_path) do
      with_tag("input#casenote_client[name=?]", "casenote[client]")
      with_tag("input#casenote_note[name=?]", "casenote[note]")
    end
  end
end

