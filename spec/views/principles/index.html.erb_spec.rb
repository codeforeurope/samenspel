require 'spec_helper'

describe "principles/index.html.erb" do
  before(:each) do
    assign(:principles, [
      stub_model(Principle,
        :title => "Title"
      ),
      stub_model(Principle,
        :title => "Title"
      )
    ])
  end

  it "renders a list of principles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
