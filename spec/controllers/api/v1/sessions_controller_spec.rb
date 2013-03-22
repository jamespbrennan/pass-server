require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before do
    @service = FactoryGirl.create(:service)
    @session = FactoryGirl.create(:session)
    @device = FactoryGirl.create(:device)

    key_pair = OpenSSL::PKey::RSA.new 2048

    @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @service.id, public_key: key_pair.public_key.to_pem)    
  end
  
  describe '#create' do
    before do
      request_payload = {
        service_id: @service.id,
      }

      post :create, request_payload
    end

    it_behaves_like 'a sucessful JSON response' do
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

  describe '#authenticate' do

    it 'should only allow `device_id`, `session_id`, and `token` parameters'
      @controller.user_params.keys.should eq(['device_id', 'session_id', 'token'])
    end

    context 'succesful authentication' do

      it_behaves_like 'a sucessful JSON response' do
      end

      it 'should include `Successful authentication`' do
        response.body.should include 'Successful authentication.'
      end

    end

    context 'unsucessful authentication' do

      it 'should retrieve a content-type of json' do
        response.header['Content-Type'].should include 'application/json'
      end

      it 'should retrieve status code of 401' do
        response.response_code.should == 401
      end

      it 'should not include `Successful authentication`' do
        response.body.should.not include 'Successful authentication.'
      end

      it 'should include `Unsuccessful authentication`' do
        response.body.should.not include 'Unsuccessful authentication.'
      end

    end

    context 'missing parameters' do
    end


    

    it 'should include `successful authentication` for valid token' do

    end

    # it 'should include `unsucessful authentication'

  end
  
end