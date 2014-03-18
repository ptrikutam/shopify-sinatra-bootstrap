require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'json'
require 'shopify_api'

class ShopifySinatra < Sinatra::Base

  def signed? #This method was based on the instructions here: http://docs.shopify.com/api/tutorials/oauth
    original_signature = params["signature"]
    params.delete("signature")
    calculated_signature = params.collect { |k, v| "#{k}=#{v}" }
    calculated_signature = calculated_signature.sort
    calculated_signature = calculated_signature.join
    calculated_signature = Digest::MD5.hexdigest(ENV['APP_API_SECRET'] + calculated_signature)
    unless original_signature == calculated_signature
      throw(:halt, [401, "This page can only be accessed from the Shopify Admin\n"])
    end
  end

  configure do
    $stdout.sync = true #Added because Heroku doesn't print logs to stdout by default.
    set :protection, :except => :frame_options #This is needed to display the app within the admin section. Sinatra blocks itself from being shown in an iFrame by default.
  end
end