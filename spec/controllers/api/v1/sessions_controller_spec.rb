require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before :all do
    @key_pair = OpenSSL::PKey::RSA.new 2048
  end
  
  describe '#create' do

    context 'valid parameters' do
      before do
        @service = FactoryGirl.create(:service)

        post :create, nil, { 'Authorization' => 'Token ' + @service.token }
      end

      it_behaves_like 'a successful JSON response' do
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

    context 'missing parameters' do
      it 'should require `Authorization` header' do
        post :create

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: service_id","code":402}}'
      end
    end

  end

  describe '#get' do

    context 'valid parameters' do
      before :each do
        @session = FactoryGirl.create(:session)

        request_payload = {
          id: @session.id
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

    context 'missing parameters' do
      it 'should require `id` parameter' do
        get :get

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: id","code":402}}'
      end
    end

  end

  describe '#authenticate' do

    # it 'should only allow `device_id`, `session_id`, and `token` parameters' do
    #   @controller.query_parameters.keys.should eq(['device_id', 'session_id', 'token'])
    # end

    context 'succesful authentication' do

      before do
        @session = FactoryGirl.create(:session)
        @device = FactoryGirl.create(:device)
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @key_pair.public_key.to_pem) 

        request_payload = {
          id: @session.id,
          device_id: @device.id,
          token: Base64::encode64(@key_pair.private_encrypt(@session.token))
        }

        post :authenticate, request_payload
      end

      it_behaves_like 'a successful JSON response' do
      end

      it 'should include `Successful authentication`' do
        response.body.should include 'Successful authentication.'
      end

    end

    context 'unsuccessful authentication' do

      before do
        @session = FactoryGirl.create(:session)
        @device = FactoryGirl.create(:device)
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @key_pair.public_key.to_pem) 

        request_payload = {
          id: @session.id,
          device_id: @device.id,
          token: Base64::encode64('foo')
        }

        post :authenticate, request_payload
      end

      it 'should retrieve a content-type of json' do
        response.header['Content-Type'].should include 'application/json'
      end

      it 'should retrieve status code of 401' do
        response.response_code.should == 401
      end

      it 'should not include `Successful authentication`' do
        response.body.should_not include 'Successful authentication.'
      end

      it 'should include `Unsuccessful authentication`' do
        response.body.should include 'Unsuccessful authentication.'
      end

    end

    context 'missing parameters' do
      before do
        @session = FactoryGirl.create(:session)
        @device = FactoryGirl.create(:device)
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @key_pair.public_key.to_pem)
      end

      it 'should require `id` parameter' do
        request_payload = {
          device_id: @device.id,
          token: Base64::encode64('foo')
        }

        post :authenticate, request_payload

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: id","code":402}}'
      end

      it 'should require `session_id` parameter' do
        request_payload = {
          id: @session.id,
          token: Base64::encode64('foo')
        }

        post :authenticate, request_payload

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: device_id","code":402}}'
      end

      it 'should require `session_id` parameter' do
        request_payload = {
          id: @session.id,
          device_id: @device.id,
        }

        post :authenticate, request_payload

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: token","code":402}}'
      end
    end

  end
  
end