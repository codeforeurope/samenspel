require 'spec_helper'

describe "principles/new.html.erb" do
  before(:each) do
    assign(:principle, stub_model(Principle,
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new principle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => principles_path, :method => "post" do
      assert_select "input#principle_title", :name => "principle[title]"
    end
  end
end
