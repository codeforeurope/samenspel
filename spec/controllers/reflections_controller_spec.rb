require 'spec_helper'

describe ReflectionsController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "should be successful" do
      get 'update'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy'
      response.should be_success
    end
  end

  describe "GET 'watch'" do
    it "should be successful" do
      get 'watch'
      response.should be_success
    end
  end

  describe "GET 'unwatch'" do
    it "should be successful" do
      get 'unwatch'
      response.should be_success
    end
  end

end
