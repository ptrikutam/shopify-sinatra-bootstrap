shopify-sinatra-bootstrap - A Sinatra-based Shopify App Template
===============

A simple Sinatra based Shopify App bootstrap. Intended as a simple guide to building a Shopify App with Sinatra, as well as a template to build simple Shopify apps. It should be easily deployable to Heroku right off the bat (with just a few config var settings).

## Prerequisites

Before you begin, make sure you're signed up for the [Shopify Partners](http://www.shopify.com/partners) program. It also assumes you're signed up for a [Heroku](https://herokuapp.com/) account and have the [Heroku Toolbelt](https://toolbelt.heroku.com/) installed. It probably is a good idea to familiarize yourself with [Sinatra](http://www.sinatrarb.com/) and the [shopify_api](https://github.com/Shopify/shopify_api) gem as well.

## Tutorial / Setup

1. Clone this repository & push it to Heroku.
  1. `git clone git@github.com:ptrikutam/shopify-sinatra.git`
  1. `cd shopify-sinatra`
  
  1. Make sure you're logged into the Heroku Toolbelt. Create an app on Heroku from the same directory as `shopify-sinatra`. 

    ```
    heroku apps:create <app name>
    Creating <app name>... done, stack is cedar
    http://<app name>.herokuapp.com/ | git@heroku.com:<app name>.git
    Git remote heroku added
    ```
  1. Push your repo up to Heroku: `git push heroku master`
1. Create an App in your Partners dashboard
  1. In your Partners dashboard, click on the "Apps" tab on the left.
  1. On the top right, click "Create App"
  1. Fill out the app information in "App Information" section.
    - If you want to create an embedded app, enable the Embedded App SDK in the "Embedded Settings". If you're not looking to create an embedded app, then you can skip this part.
  1. Fill out the App URLs section. The only required part here is the Application Callback URL. Set this to be **https**://<your_app>.herokuapp.com. **Make sure you use https, or Shopify will have issues with it from inside the Shopify Admin**.
  1. Finish filling out the rest of the form, and create your app.
1. Update the following config vars on Heroku. You can find this on your app's page in your Partners dashboard. You should also specify an additional callback URL to redirect to once your app has been authorized.

  ```
  heroku config:set SHOPIFY_CALLBACK_URL="https://<app name>.herokuapp.com/login/finalize" --app <app name>
  heroku config:set SHOPIFY_API_KEY=<your app's API key> --app <app name>
  heroku config:set SHOPIFY_SHARED_SECRET=<you app's shared secret> --app <app name>
  ```
1. Hit the URL heroku gave you, should be something like: http://<app name>.herokuapp.com/. This will automatically redirect you to a login page where you can authenticate with a shop.


### Acknowledgements

This project was inspired by [@jstorimer's](https://github.com/jstorimer) [sinatra-shopify](https://github.com/jstorimer/sinatra-shopify), a classy shopify_app. Reading through his code led me to the [Sinatra page on writing extensions](http://www.sinatrarb.com/extensions.html), which led me to build a slightly more modular version of this code.
