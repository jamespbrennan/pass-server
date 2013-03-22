require 'spec_helper'

describe Api::V1::UsersController do
  render_views

  describe '#create' do
    before :all do
      @email = 'createusertest@example.com'
      @password = 'secret'
    end

    context 'valid parameters' do
      before do
        request_payload = {
          email: @email,
          password: @password
        }

        post :create, request_payload
      end

      it_behaves_like 'a successful JSON response' do
      end

      it 'should respond with id' do
        response.body.should include("\"id\":#{assigns(:user).id}")
      end

      it 'should respond with email' do
        response.body.should include("\"email\":\"#{assigns(:user).email}\"")
      end

      it 'should create a user' do
        # assigns(:user).should be_new_record
        assigns(:user).email.should == @email
        assigns(:user).authenticate(@password).should be_true
      end

    end

    context 'missing parameters' do
      it 'should require `email` parameter' do
        request_payload = {
          password: @password
        }

        post :create, request_payload

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: email","code":402}}'
      end

      it 'should require `password` parameter' do
        request_payload = {
          email: @email,
        }

        post :create, request_payload

        response.body.should == '{"error":{"type":"invalid_request_error","message":"param not found: password","code":402}}'
      end
    end

  end
  
end