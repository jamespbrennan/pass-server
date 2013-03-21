require 'spec_helper'

describe Api::V1::ErrorsController do
  render_views
  
  describe "#routing" do
    before do
      get :routing
    end

    it "should retrieve a content-type of json" do
      response.header['Content-Type'].should include 'application/json'
    end

    it "should retrieve status code of 404" do
      response.response_code.should == 404
    end

    it 'should include `"type":"invalid_request_error"`' do
      response.body.should include '"type":"invalid_request_error"'
    end

    it 'should include `"code":404`' do
      response.body.should include '"code":404'
    end
  end
  
end