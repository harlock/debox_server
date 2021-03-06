module DeboxServer
  module API
    module V1

      class ACL < Grape::API

        version 'v1'

        before do
          authenticate!
        end


        helpers do

          def allowed?
            action = params[:action].to_sym
            user = current_user
            # Admins can override users
            if params[:user] && current_user.admin
              user = User.find_by_email params[:user]
            end
            if user.can? action, on: current_env
              return "YES"
            else
              error!("User is not allowed to run this action", 403)
            end
          end

          def actions
            user = current_user
            # Admins can override users
            if params[:user] && current_user.admin
              user = User.find_by_email params[:user]
            end
            user.permissions.map(&:action)
          end

          def add_action(action, email)
            require_admin
            user = User.find_by_email email
            error!("User not found", 400) unless user
            user.permissions.create(recipe: current_env, action: action)
          end

          def remove_action(action, user_id)
            require_admin
            user = User.find_by_email user_id
            error!("User not found", 400) unless user
            permission = user.permissions_for_recipe(current_env).where(action: action).first
            error!("Permission not found", 400) unless permission
            permission.destroy
          end

        end

        resource :acl do

          # allowed
          #----------------------------------------------------------------------

          desc "Check if the user is authorized for a given action and env"
          params do
            requires :action, type: String, desc: "action"
            optional :user, type: String, desc: "optional user. Require admin access."
          end
          get '/allowed/:app/:env' do
            allowed?
          end

          desc "Check if the user is authorized for a given action and default env"
          params do
            requires :action, type: String, desc: "action"
            optional :user, type: String, desc: "optional user. Require admin access."
          end
          get '/allowed/:app' do
            allowed?
          end

          # action index
          #----------------------------------------------------------------------

          desc "List actions for a user in the app acl."
          params do
            optional :user, type: String, desc: "optional user. Require admin access."
          end
          get '/actions/:app/:env' do
            (actions || []).to_json
          end

          desc "List actions for a user in the app acl."
          params do
            optional :user, type: String, desc: "optional user. Require admin access."
          end
          get '/actions/:app' do
            (actions || []).to_json
          end

          # add action
          #----------------------------------------------------------------------

          desc "Add action for a user to the app acl. Require admin access"
          params do
            requires :action, type: String, desc: "action"
            requires :user, type: String, desc: "user."
          end
          post '/actions/:app/:env' do
            add_action params[:action], params[:user]
            "OK"
          end

          desc "Add action for a user to the app acl. Require admin access"
          params do
            requires :action, type: String, desc: "action"
            requires :user, type: String, desc: "user."
          end
          post '/actions/:app' do
            add_action params[:action], params[:user]
            "OK"
          end

          # remove action
          #----------------------------------------------------------------------

          desc "Remove action for a user from the app acl. Require admin access"
          params do
            requires :action, type: String, desc: "action"
            requires :user, type: String, desc: "user."
          end
          delete '/actions/:app/:env' do
            remove_action params[:action], params[:user]
            "OK"
          end

          desc "Remove action for a user from the app acl. Require admin access"
          params do
            requires :action, type: String, desc: "action"
            requires :user, type: String, desc: "user."
          end
          delete '/actions/:app' do
            remove_action params[:action], params[:user]
            "OK"
          end
        end

      end
    end
  end
end
