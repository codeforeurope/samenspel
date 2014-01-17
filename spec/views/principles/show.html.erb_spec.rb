require 'spec_helper'

describe "principles/show.html.erb" do
  before(:each) do
    @principle = assign(:principle, stub_model(Principle,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
  end
end
