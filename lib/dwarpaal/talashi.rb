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
      default_options = {
          :initial_max_hits => 100,
          :allowed_increase => 20,
          :code => 403,
          :message => 'Too Many request for the day'
      }
      options = default_options.merge options
      @app, @options = app, options
    end

    ##
    # @param  [Hash{String => String}] env
    # @return [Array(Integer, Hash, #each)]
    # @see    http://rack.rubyforge.org/doc/SPEC.html
    def call(env)
      puts 'request captured'
      request = Rack::Request.new(env)
      RequestLog.log(request)
      allowed?(request) ? app.call(env) : rate_limit_exceeded(request)
    end

    protected

    def allowed?(request)
      today_count = RequestLog.count_on_day(Date.today, request.ip)
      return true if today_count <= options[:initial_max_hits]
      week_ago_count = RequestLog.count_on_day(Date.today-7, request.ip)
      # true if less than or equal to allowed increase per week else false
      today_count <= week_ago_count*((100.0 +options[:allowed_increase])/100)
    end

    ##
    # @param  [Rack::Request] request
    # @return [Float]
    def request_start_time(request)
      # Check whether HTTP_X_REQUEST_START or HTTP_X_QUEUE_START exist and parse its value (for
      # example, when having nginx in your stack, it's going to be in the "t=\d+" format).
      if val = (request.env['HTTP_X_REQUEST_START'] || request.env['HTTP_X_QUEUE_START'])
        val[/(?:^t=)?(\d+)/, 1].to_f / 1000
      else
        Time.now.to_f
      end
    end

    ##
    # Outputs a `Rate Limit Exceeded` error.
    #
    # @return [Array(Integer, Hash, #each)]
    def rate_limit_exceeded(request)
      options[:rate_limit_exceeded_callback].call(request) if options[:rate_limit_exceeded_callback]
      headers = respond_to?(:retry_after) ? {'Retry-After' => retry_after.to_f.ceil.to_s} : {}
      http_error(options[:code] , options[:message] , headers)
    end

    ##
    # Outputs an HTTP `4xx` or `5xx` response.
    #
    # @param  [Integer]                code
    # @param  [String, #to_s]          message
    # @param  [Hash{String => String}] headers
    # @return [Array(Integer, Hash, #each)]
    def http_error(code, message = nil, headers = {})
      [code, {'Content-Type' => 'text/plain; charset=utf-8'}.merge(headers),
       [http_status(code), (message.nil? ? "\n" : " (#{message})\n")]]
    end

    ##
    # Returns the standard HTTP status message for the given status `code`.
    #
    # @param  [Integer] code
    # @return [String]
    def http_status(code)
      [code, Rack::Utils::HTTP_STATUS_CODES[code]].join(' ')
    end

    def retry_after
      86400 # after a day
    end
  end
end