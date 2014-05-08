Bundler.require :default, ENV['RACK_ENV']

require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  set :assets_host, 'datenshizero.github.io'
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier

  register Sinatra::AssetPipeline

  get '/' do
    haml :index
  end
end
