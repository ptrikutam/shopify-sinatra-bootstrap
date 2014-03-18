require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'json'
require 'shopify_api'

require_relative 'modules/shopify_app'


class ShopifySinatra < Sinatra::Base
  register Sinatra::ShopifyApp

  configure do
    $stdout.sync = true #Added because Heroku doesn't print logs to stdout by default.
    set :protection, :except => :frame_options #This is needed to display the app within the admin section. Sinatra blocks itself from being shown in an iFrame by default.
  end

  get '/' do
    authorize!
    haml :index
  end

  get '/admin' do
    authorize!
    sign!(params)
    haml :admin
  end

end