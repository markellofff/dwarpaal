module Dwarpaal
  class Talashi
    attr_reader :app
    attr_reader :options

    ##
    # @param  [#call]                       app
    # @param  [Hash{Symbol => Object}]      options
    # @option options [String]  :cache      (Hash.new)
    # @option options [String]  :key        (nil)
    # @option options [String]  :key_prefix (nil)
    # @option options [Integer] :code       (403)
    # @option options [String]  :message    ("Rate Limit Exceeded")
    def initialize(app, options = {})
      @app, @options = app, options
    end

    ##
    # @param  [Hash{String => String}] env
    # @return [Array(Integer, Hash, #each)]
    # @see    http://rack.rubyforge.org/doc/SPEC.html
    def call(env)
      puts 'request captured'
      request = Rack::Request.new(env)
      allowed?(request) ? app.call(env) : rate_limit_exceeded(request)
    end

    def allowed?(request)
      true
    end

    def rate_limit_exceeded(request)
      'bad manners'
    end
  end
end