require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/casenotes/edit.html.erb" do
  include ClientHelper

  before(:each) do
    assigns[:casenote] = @casenote = stub_model(Casenote,
      :new_record? => false,
      :client => ,
      :note => "value for note"
    )
  end

  it "renders the edit casenote form" do
    render

    response.should have_tag("form[action=#{casenote_path(@casenote)}][method=post]") do
      with_tag('input#casenote_client[name=?]', "casenote[client]")
      with_tag('input#casenote_note[name=?]', "casenote[note]")
    end
  end
end

