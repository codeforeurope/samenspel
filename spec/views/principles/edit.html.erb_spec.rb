require 'spec_helper'

describe "principles/edit.html.erb" do
  before(:each) do
    @principle = assign(:principle, stub_model(Principle,
      :title => "MyString"
    ))
  end

  it "renders the edit principle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => principle_path(@principle), :method => "post" do
      assert_select "input#principle_title", :name => "principle[title]"
    end
  end
end
