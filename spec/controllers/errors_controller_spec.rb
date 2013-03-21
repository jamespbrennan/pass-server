require 'spec_helper'

describe Api::V1::ErrorsController do
  
  describe "#routing" do
    before do
      get :index
    end

    it "should retrieve a content-type of json" do
      response.header['Content-Type'].should include 'application/json'
    end
  end
end