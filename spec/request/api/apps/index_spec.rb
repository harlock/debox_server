require 'spec_helper'
describe '/v1/apps' do
  it 'should return an empty array without apps' do
    login_user
    server = FakeServer.new
    get '/v1/apps'
    last_response.should be_ok
    last_response.body.should eq [].to_json
  end


  it 'should return current apps if any' do
    login_user
    server = FakeServer.new

    server.apps_create 'test'
    server.apps_create 'test2'
    server.create_recipe('test', :production, 'content')
    server.create_recipe('test2', :dev, 'content')

    get '/v1/apps'
    last_response.should be_ok
    last_response.body.should eq [{:app=>"test", :envs=>["production"]}, {:app=>"test2", :envs=>["dev"]}].to_json
  end
end
