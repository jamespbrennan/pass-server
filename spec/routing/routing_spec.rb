require 'spec_helper'

describe UsersController do
  it 'should route to #signup' do
    get('/signup').should route_to('users#new')
  end
end

describe SessionsController do
  it 'should route to #login for regular domain' do
    get('http://domain.com/login').should route_to('sessions#new')
  end

  it 'should not route to #login for api subdomain' do
    get('http://api.domain.com/login').should route_to(controller: 'api/v1/errors', action: 'routing', a: 'login', subdomain: 'api')
  end

  it 'should route to #logout for regular domain' do
    get('http://domain.com/logout').should route_to('sessions#destroy')
  end

  it 'should not route to #logout for api subdomain' do
    get('http://api.domain.com/logout').should route_to(controller: 'api/v1/errors', action: 'routing', a: 'logout', subdomain: 'api')
  end

  it 'should route to #new for regular domain' do
    get('http://domain.com/sessions/new').should route_to('sessions#new')
  end

  it 'should not route to #new for api subdomain' do
    get('http://api.domain.com/sessions/new').should route_to(controller: 'api/v1/errors', action: 'routing', a: 'sessions/new', subdomain: 'api')
  end
end

describe DevicesController do
  it 'should route to #index for regular domain' do
    get('http://domain.com/devices').should route_to('devices#index')
  end

  it 'should not route to #index for api subdomain' do
    get('http://api.domain.com/devices').should route_to(controller: 'api/v1/errors', action: 'routing', a: 'devices', subdomain: 'api')
  end

  it 'should route to #show for regular domain' do
    get('http://domain.com/devices/1').should route_to(controller: 'devices', action: 'show', id: '1')
  end

  it 'should not route to #index for api subdomain' do
    get('http://api.domain.com/devices/1').should route_to(controller: 'api/v1/errors', action: 'routing', a: 'devices/1', subdomain: 'api')
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
    get("http://domain.com/foo/bar").should_not be_routable
    post("http://domain.com/foo/bar").should_not be_routable
    delete("http://domain.com/foo/bar").should_not be_routable
    #TODO patch currently isn't supported
    # patch("http://domain.com/foo/bar").should_not be_routable
    put("http://domain.com/foo/bar").should_not be_routable
  end
end

describe Api::V1::SessionsController do
  it 'should route to #create for api subdomain' do
    post('http://api.domain.com/sessions').should route_to(controller: 'api/v1/sessions', action: 'create', subdomain: 'api')
  end

  it 'should not route to #create for regular domain' do
    post('http://domain.com/sessions').should route_to(controller: 'sessions', action: 'create')
  end

  it 'should route to #get for api subdomain' do
    get('http://api.domain.com/sessions').should route_to(controller: 'api/v1/sessions', action: 'get', subdomain: 'api')
  end

  it 'should not route to #get for regular domain' do
    get('http://domain.com/sessions').should route_to(controller: 'sessions', action: 'index')
  end

  it 'should route to #activate for api subdomain' do
    post('http://api.domain.com/sessions/authenticate').should route_to(controller: 'api/v1/sessions', action: 'authenticate', subdomain: 'api')
  end

  it 'should not route to #activate for regular domain' do
    post('http://domain.com/sessions/authenticate').should_not be_routable
  end
end

describe Api::V1::DevicesController do
  it 'should route to #create for api subdomain' do
    post('http://api.domain.com/devices').should route_to(controller: 'api/v1/devices', action: 'create', subdomain: 'api')
  end

  it 'should not route to #create for regular domain' do
    post('http://domain.com/devices').should route_to(controller: 'devices', action: 'create')
  end

  it 'should route to register for api subdomain' do
    post('http://api.domain.com/devices/register').should route_to(controller: 'api/v1/devices', action: 'register', subdomain: 'api')
  end

  it 'should not route to register for regular domain' do
    post('http://domain.com/devices/register').should_not be_routable
  end
end

describe Api::V1::UsersController do
  it 'should route to #create for api subdomain' do
    post('http://api.domain.com/users').should route_to(controller: 'api/v1/users', action: 'create', subdomain: 'api')
  end
end
