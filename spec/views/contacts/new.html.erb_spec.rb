require 'spec_helper'

describe "contacts/new.html.erb" do
  before(:each) do
    assign(:contact, stub_model(Contact,
      :first_name => "MyString",
      :last_name => "MyString",
      :organization => "MyString",
      :location => "MyString",
      :email => "MyString",
      :phone_number => "MyString",
      :address => "MyText"
    ).as_new_record)
  end

  it "renders new contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contacts_path, :method => "post" do
      assert_select "input#contact_first_name", :name => "contact[first_name]"
      assert_select "input#contact_last_name", :name => "contact[last_name]"
      assert_select "input#contact_organization", :name => "contact[organization]"
      assert_select "input#contact_location", :name => "contact[location]"
      assert_select "input#contact_email", :name => "contact[email]"
      assert_select "input#contact_phone_number", :name => "contact[phone_number]"
      assert_select "textarea#contact_address", :name => "contact[address]"
    end
  end
end
