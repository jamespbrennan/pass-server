require 'spec_helper'

describe Api::V1::SessionsController do
  render_views

  before :all do
    @key_pair = Crypto::PrivateKey.generate
    @signing_key = Crypto::SigningKey.new @key_pair
    @verify_key = Crypto::VerifyKey.new @key_pair.public_key
  end
  
  describe '#create' do

    context 'valid parameters' do
      before do
        @service = FactoryGirl.create(:service)
        request.env['HTTP_AUTHORIZATION'] = "Token #{@service.api_tokens.first.token}"
        post :create
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

  end

  describe '#get' do
    context 'valid parameters' do
      before :each do
        @user = FactoryGirl.create(:user)
        @device = FactoryGirl.create(:device, user: @user)
        @service = FactoryGirl.create(:service)
        @device_account = FactoryGirl.create(:device_account, device: @device, service: @service)
        @session = FactoryGirl.create(:session, service: @service, device: @device)

        request_payload = {
          id: @session.id
        }

        request.env['HTTP_AUTHORIZATION'] = "Token #{@service.api_tokens.first.token}"
        get :get, request_payload
      end

      it_behaves_like 'a successful JSON response' do
      end

      it 'should include id' do
        response.body.should include "\"id\":#{@session.id}"
      end

      it 'should include user id' do
        response.body.should include "\"id\":#{@user.id}"
      end

      it 'should include user email' do
        response.body.should include "\"email\":\"#{@user.email}\""
      end
    end
  end

  describe '#authenticate' do

    context 'valid parameters' do
      before :each do
        @session = FactoryGirl.create(:session)

        request_payload = {
          id: @session.id
        }

        get :authenticate, request_payload
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
        get :authenticate

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: id","code":406}}'
      end
    end

  end

  describe '#do_authentication' do

    # it 'should only allow `device_id`, `session_id`, and `token` parameters' do
    #   @controller.query_parameters.keys.should eq(['device_id', 'session_id', 'token'])
    # end

    context 'succesful authentication' do

      before do
        @session = FactoryGirl.create(:session)
        @device = FactoryGirl.create(:device)
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @verify_key.to_s(:hex)) 

        request_payload = {
          id: @session.id,
          device_id: @device.id,
          token: @signing_key.sign(@session.token, :hex)
        }

        request.env['HTTP_AUTHORIZATION'] = "Token #{@device.api_token.token}"
        post :do_authentication, request_payload
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
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @verify_key.to_s(:hex)) 

        request_payload = {
          id: @session.id,
          token: 'blah'
        }

        request.env['HTTP_AUTHORIZATION'] = "Token #{@device.api_token.token}"
        post :do_authentication, request_payload
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
        @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @session.service.id, public_key: @verify_key.to_s(:hex))
      end

      it 'should require `id` parameter' do
        post :do_authentication, nil, { authorization: "Token #{@device.api_token.token}" }

        response.code == 401
        # response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: id","code":402}}'
      end
    end

  end
  
end