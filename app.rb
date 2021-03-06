require "rubygems"
require "bundler"
Bundler.require

# DataMapper
#
# DataMapper::Logger.new(STDOUT, :debug)
# DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/app_development")

Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |model| require model }

require './helpers'

class App < Sinatra::Base
  register Sinatra::Contrib
  # If you run into issues with click-jacking (like with Facebook
  # Canvas apps), or with CSRF issues, you may want to disable
  # sinatra-contrib's default protection:
  #
  # disable :protection
  
  # Sinatra uses some dumb default
  set :json_encoder, :to_json
  
  # Sequel
  #
  # DB = Sequel.connect(ENV['DATABASE_URL'] || "mysql2://root:root@localhost/app_development")
  # DB.loggers << Logger.new(STDOUT)
  
  # Redis
  # 
  # $redis = Redis::Namespace.new(:appname, :redis => Redis.new({
  #   :url => ENV['REDIS_URL'], 
  #   :logger => Logger.new(STDOUT)
  # }))
  
  set :root, File.dirname(__FILE__)
  set :sprockets, (Sprockets::Environment.new(root) { |env| env.logger = Logger.new(STDOUT) })
  
  set :assets_path, File.join(root, 'assets')
  # look for gems in asset folders
  %w{javascripts stylesheets images}.each do |subdir|
    sprockets.append_path File.join(root, 'assets', subdir)
    %w{vendor lib app}.each do |base_dir|  
      # load for all gems
      Gem.loaded_specs.map(&:last).each do |gemspec|
        path = File.join(gemspec.gem_dir, base_dir, "assets", subdir)
        sprockets.append_path path if File.directory? path
      end
    end
  end
  
  configure :development do
    register Sinatra::Reloader
    also_reload "./**.rb"
  end
  
  # rack middleware to parse json body
  use Rack::PostBodyContentTypeParser
  
  helpers Sinatra::AssetHelpers

  get "/" do
    haml :index
  end
end

# more DataMapper
#
# DataMapper.finalize