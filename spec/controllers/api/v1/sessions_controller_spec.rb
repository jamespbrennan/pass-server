require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before do
    @service = FactoryGirl.create(:service)
    @session = FactoryGirl.create(:session)
  end
  
  describe '#create' do
    before do
      request_payload = {
        service_id: @service.id,
      }

      post :create, request_payload
    end

    it 'should retrieve a content-type of json' do
      response.header['Content-Type'].should include 'application/json'
    end

    it 'should retrieve status code of 200' do
      response.response_code.should == 200
    end

    it 'should include `"id":`' do
      response.body.should include('"id":')
    end

    it 'should include `"service_id":`' do
      response.body.should include "\"service_id\":#{@service.id.to_s}"
    end

    it 'should not include `"token":`' do
      response.body.should_not include 'token":'
    end

    it 'should include `"created_at":`' do
      response.body.should include '"created_at":'
    end

  end

  describe '#get' do
    before do
      request_payload = {
        id: @session.id,
      }

      get :get, request_payload
    end

    it 'should retrieve a content-type of html' do
      response.header['Content-Type'].should include 'text/html'
    end

    it 'should retrieve a X-Frame-Option matching the service url' do
      response.header['X-Frame-Options'].should == "ALLOW-FROM #{@session.service.url}"
    end

    it 'should retrieve status code of 200' do
      response.response_code.should == 200
    end

    it 'should include `data-session-id`' do
      response.body.should include "data-session-id=\"#{@session.id}\""
    end

    it 'should include `data-service-id`' do
      response.body.should include "data-service-id=\"#{@session.service.id}\""
    end

    it 'should not include `data-token-id`' do
      response.body.should include "data-token=\"#{@session.token}\""
    end

  end
  
end