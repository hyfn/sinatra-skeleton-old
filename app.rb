require "rubygems"
require "bundler"
Bundler.require

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/app_development")
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |model| require model }

require './helpers'

class App < Sinatra::Base
  register Sinatra::Contrib
  # If you run into issues with click-jacking (like with Facebook
  # Canvas apps), or with CSRF issues, you may want to disable
  # sinatra-contrib's default protection:
  #
  # disable :protection

  set :root, File.dirname(__FILE__)
  set :sprockets, (Sprockets::Environment.new(root) { |env| env.logger = Logger.new(STDOUT) })
  set :assets_path, File.join(root, 'assets')

  configure do
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
  end
  
  configure :development do
    register Sinatra::Reloader
    also_reload "./**.rb"
  end
  
  helpers Sinatra::AssetHelpers

  get "/" do
    # ...
  end
end

DataMapper.finalize