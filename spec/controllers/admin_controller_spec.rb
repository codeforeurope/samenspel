require 'spec_helper'

describe AdminController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'users'" do
    it "should be successful" do
      get 'users'
      response.should be_success
    end
  end

  describe "GET 'projects'" do
    it "should be successful" do
      get 'projects'
      response.should be_success
    end
  end

  describe "GET 'teams'" do
    it "should be successful" do
      get 'teams'
      response.should be_success
    end
  end

end
