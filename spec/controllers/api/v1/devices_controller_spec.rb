require 'spec_helper'

describe Api::V1::DevicesController do
  render_views
  
  describe '#create' do
    before :each do
      @password = 'secret'
      @user = FactoryGirl.create(:user, password: @password)

      post :create, { email: @user.email, password: @password, name: 'My device' }
    end

    it_behaves_like 'a successful JSON response'

    it 'should include `id`' do
      response.body.should include '"id":'
    end

    it 'should include `name`' do
      response.body.should include '"name":'
    end

    it 'should include `token`' do
      response.body.should include '"token":'
    end
  end

  describe '#register' do
    before :each do
      @service = FactoryGirl.create(:service)
      @device = FactoryGirl.create(:device)
      @key_pair = OpenSSL::PKey::RSA.new 2048

      request.env['HTTP_AUTHORIZATION'] = "Token #{@device.api_token.token}"
      post :register, { service_id: @service.id, public_key: @key_pair.public_key.to_pem }
    end

    it_behaves_like 'a successful JSON response'

    it 'should include `device_id`' do
      response.body.should include '"device_id":'
    end
  end

end
