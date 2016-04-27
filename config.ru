# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

require 'rack/cors'

use Rack::Cors do
  allow do
    # origins 'http://gustavosobral.github.io/', 'http://localhost:8080'
    origins '*'

    resource '/api/*',
	 :headers => :any,
	 :methods => [:get, :post, :put, :patch]
   end
end
