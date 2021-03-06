module DeboxServer::API::V1

  class Apps < Grape::API

    version 'v1'
    format :json

    before do
      # authenticate!
    end

    helpers do
      def server_status
        jobs_queue.status
      end
    end

    desc "Return server status"
    get '/status' do
      server_status
    end

  end
end
