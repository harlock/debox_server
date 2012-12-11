module DeboxServer
  module API
    module V1

      class Logs < Grape::API

        version 'v1'
        format :json

        before do
          authenticate!
        end

        helpers do

          def get_logs_helper(app, env)
            logs = deployer_logs app, env
            out = logs.map do |l|
              { status: l[:status], task: l[:task], time: l[:time], error: l[:error] }
            end
            out
          end
        end

        resource :logs do

          get "/:app" do
            get_logs_helper current_app, current_env
          end

          get "/:app/:env" do
            get_logs_helper current_app, current_env
          end

          # TODO change route
          get "/:app/:env/:index" do
            index = params[:index] == 'last' ? 0 : params[:index]
            log = deployer_logs_at current_app, current_env, index
            error!("Log not found", 400) unless log
            log[:log]
          end

        end
      end
    end
  end
end
