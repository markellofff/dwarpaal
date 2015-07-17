# Dwarpaal

Gem to block excessive/unwanted requests. This gem right now works only with rails.

## Installation

Add this line to your application's Gemfile:

    gem 'dwarpaal', :github => 'ranupratapsingh/dwarpaal', :branch=>'master'


And then execute:

    bundle


## Usage

TO use this gem

 1. include it in Gemfile
 2. run bundle install
 3. run following command from rails root ```rails g migration CreateRequestLog ip_address:string c_date:date req_path:text```
 4. in `config/application.rb` add following configuration

Sample Code:

    class Application < Rails::Application
      config.middleware.use Dwarpaal::Talashi, :initial_max_hits => 10
    end

## Customize Options
We can give additional options for the Gem like below

    class Application < Rails::Application
      config.middleware.use Dwarpaal::Talashi, :initial_max_hits => 10
    end

All acceptable options are:

 1. initial_max_hits -> per day allowed hits without check
 2. allowed_increase -> allowed percentage increase for a week
 3. code -> response code when not allowed
 4. message -> message when request is not allowed
