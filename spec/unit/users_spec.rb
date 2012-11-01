require 'spec_helper'

describe 'DeboxServer::Users#add_users' do
  it 'should add a user to the db' do
    app = FakeServer.new
    app.add_user('test@indeos.es', 'password')
    user_data = app.users_config['test@indeos.es']
    user_data[:password].should eq hash_str 'password'
  end
end

describe 'DeboxServer::Users#users_config' do
  it 'should return an empty object if empty' do
    app = FakeServer.new
    expected = { }
    app.users_config.should eq expected
  end
end

describe 'DeboxServer::Users#login_user' do
  it 'should return false if the user does not exists' do
    app = FakeServer.new
    app.login_user('invalid@indeos.es', 'password').should be_false
  end

  it 'should return the user data if the user exists' do
    app = FakeServer.new
    app.add_user('test@indeos.es', 'password')
    data = app.login_user('test@indeos.es', 'password')
    data.should_not be_false
    data[:password].should eq hash_str 'password'
  end
end
