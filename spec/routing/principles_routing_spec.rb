require "spec_helper"

describe PrinciplesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/principles" }.should route_to(:controller => "principles", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/principles/new" }.should route_to(:controller => "principles", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/principles/1" }.should route_to(:controller => "principles", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/principles/1/edit" }.should route_to(:controller => "principles", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/principles" }.should route_to(:controller => "principles", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/principles/1" }.should route_to(:controller => "principles", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/principles/1" }.should route_to(:controller => "principles", :action => "destroy", :id => "1")
    end

  end
end
