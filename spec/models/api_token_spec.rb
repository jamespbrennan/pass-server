require 'spec_helper'

describe ApiToken do
  before do
    @api_token = FactoryGirl.create(:api_token)
  end

  it 'should generate a token' do
    @api_token.token.should_not be_blank
  end

  it 'should generate a unique token each time' do
    new_api_token = FactoryGirl.create(:api_token)
    @api_token.token.should_not == new_api_token.token
  end

end