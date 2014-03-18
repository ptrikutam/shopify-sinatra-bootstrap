module Sinatra
  module ShopifyApp

    module Helpers
      def current_shop
        session[:shopify]
      end

      def sign!(params) #You can use this method if you want to make your app only accessible from the Shopify Admin
        unless ShopifyAPI::Session.validate_signature(params)
          throw(:halt, [401, "This page can only be accessed from the Shopify Admin\n"])
        end
        # unless params["signature"]
        #   throw(:halt, [401, "This page can only be accessed from the Shopify Admin\n"])
        # end
        # original_signature = params["signature"]
        # params.delete("signature")
        # calculated_signature = params.collect { |k, v| "#{k}=#{v}" })
        # calculated_signature = calculated_signature.sort
        # calculated_signature = calculated_signature.join
        # calculated_signature = Digest::MD5.hexdigest(ENV['SHOPIFY_SHARED_SECRET'] + calculated_signature)
        # unless original_signature == calculated_signature
        #   throw(:halt, [401, "This page can only be accessed from the Shopify Admin\n"])
        # end
      end

      def authorize!
        redirect '/login' unless current_shop
        ShopifyAPI::Base.site = session[:shopify].site
      end

      def logout!
        session[:shopify] = nil
      end
    end

    def self.registered(app)
      app.helpers ShopifyApp::Helpers
      app.enable :sessions

      unless ENV['SHOPIFY_API_KEY'] && ENV['SHOPIFY_SHARED_SECRET']
        puts "Set your Shopify api_key and secret via ENV['SHOPIFY_API_KEY'] and ENV['SHOPIFY_SHARED_SECRET']"
      end
      ShopifyAPI::Session.setup(:api_key => ENV['SHOPIFY_API_KEY'], :secret => ENV['SHOPIFY_API_SECRET'])

      app.get '/login' do
        haml :login
      end

      app.post '/login/authenticate' do
        #Define the scope of the permissions you'd like. For reference, all possible permissions are listed here.
        scope = ["write_content","write_themes","write_products","write_customers","write_orders","write_script_tags","write_fulfillments","write_shipping"]
        redirect to(ShopifyAPI::Session.new(params[:shop]).create_permission_url(scope,ENV['FINALIZE_URL']))
      end

      app.get '/login/finalize' do
        
        # Retrieve the access token
        token_response = Net::HTTP.post_form(URI.parse("https://#{params[:shop]}/admin/oauth/access_token"), {
          "client_id" => ENV['SHOPIFY_API_KEY'],
          "client_secret" => ENV['SHOPIFY_SHARED_SECRET'],
          "code" => params[:code],
        })

        token = JSON.parse(token_response.body)

        shopify_session = ShopifyAPI::Session.new(params[:shop], token["access_token"])
        if shopify_session.valid?
          session[:shopify] = shopify_session
          return_address = session[:return_to] || '/'
          session[:return_to] = nil
          redirect return_address
        else
          redirect '/login'
        end
      end
    end
  end

  register ShopifyApp
end