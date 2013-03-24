require 'spec_helper'

describe UsersController do
  it 'to #signup' do
    get('/signup').should route_to('users#new')
  end
end

describe SessionsController do
  it 'to #login' do
    get('/login').should route_to('sessions#new')
  end

  it 'to #logout' do
    get('/logout').should route_to('sessions#destroy')
  end
end

describe Api::V1::ErrorsController do
  it 'should show API error for api subdomain' do
    get("http://api.domain.com/foo/bar").should route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar', subdomain: 'api')
    post("http://api.domain.com/foo/bar").should route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar', subdomain: 'api')
    delete("http://api.domain.com/foo/bar").should route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar', subdomain: 'api')
    #TODO patch currently isn't supported
    # patch("http://api.domain.com/foo/bar").should route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar', subdomain: 'api')
    put("http://api.domain.com/foo/bar").should route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar', subdomain: 'api')
  end

  it 'should not show API error for regular domain' do
    get("http://domain.com/foo/bar").should_not route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar')
    post("http://domain.com/foo/bar").should_not route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar')
    delete("http://domain.com/foo/bar").should_not route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar')
    #TODO patch currently isn't supported
    # patch("http://domain.com/foo/bar").should_not route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar')
    put("http://domain.com/foo/bar").should_not route_to(controller: 'api/v1/errors', action: 'routing', a: 'foo/bar')
  end
end

describe Api::V1::SessionsController do
  it 'should route to #create for api subdomain' do
    post('http://api.domain.com/sessions').should route_to(controller: 'api/v1/sessions', action: 'create', subdomain: 'api')
  end

  it 'should not route to #create for regular domain' do
    post('http://domain.com/sessions').should_not route_to(controller: 'api/v1/sessions', action: 'create')
  end

  it 'should route to #get for api subdomain' do
    get('http://api.domain.com/sessions').should route_to(controller: 'api/v1/sessions', action: 'get', subdomain: 'api')
  end

  it 'should not route to #get for regular domain' do
    get('http://domain.com/sessions').should_not route_to(controller: 'api/v1/sessions', action: 'get')
  end

  it 'should route to #activate for api subdomain' do
    post('http://api.domain.com/sessions/authenticate').should route_to(controller: 'api/v1/sessions', action: 'authenticate', subdomain: 'api')
  end

  it 'should not route to #activate for regular domain' do
    post('http://domain.com/sessions/authenticate').should_not route_to(controller: 'api/v1/sessions', action: 'authenticate')
  end
end