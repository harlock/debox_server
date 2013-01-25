require 'json'
require 'fileutils'
require 'erb'

require 'grape'
# require 'rack/stream'



# TODO get root without the ../
DEBOX_ROOT = File.join(File.dirname(__FILE__), '../')

require "debox_server/version"
require "debox_server/logger"
require "debox_server/config"
require "debox_server/utils"
require 'debox_server/redis'
require 'debox_server/activerecord'
require "debox_server/ssh_keys"
require "debox_server/apps"
require "debox_server/users"
require "debox_server/recipes"
require "debox_server/deploy_logs"
require "debox_server/job"
require "debox_server/deployer"
require "debox_server/acl"

require "debox_server/basic_auth"
require "debox_server/view_helpers"

require "debox_server/core"

require "debox_server/api"
