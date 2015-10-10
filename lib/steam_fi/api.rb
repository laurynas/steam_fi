require 'net/http'
require 'uri'
require 'yaml'

module SteamFi
  class API
    # Default configuration 
    @@config = {
      :sms_url  => 'https://pipe.steam.fi/contentbroker/api/sendsms',
      :username => nil,
      :password => nil
    }

    @@logger = nil
    
    class << self
      def setup(options)
        @@config.merge!(options)
      end
      
      # Send SMS message
      def send_sms(msisdn, message, params = {})
        params.merge! :msisdn => msisdn, :msg => message
        request @@config[:sms_url], params
      end

      def logger
        @@logger
      end
      
      def logger=(logger)
        @@logger = logger
      end    
      
      protected
      
      # Send request
      def request(url, params = {})
        # add username & password
        params.merge! :l => @@config[:username], :p => @@config[:password]
        
        logger.info "#{Time.now} REQUEST\n#{url}\n#{params.to_yaml}" if logger

        begin
          # build & send request
          uri = URI.parse(url)
          req = Net::HTTP::Post.new(uri.path)
          
          req.set_form_data(params)
          req.initialize_http_header({ 
            'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
          })
          
          http          = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl  = (uri.port == 443)
          res           = http.request(req) 
        rescue Exception => e
          handle_error e
        end
          
        case res
        when Net::HTTPSuccess
          logger.info "#{Time.now} RESPONSE\n#{res.body}" if logger
          res.body
        else
          handle_error SteamFi::SteamException.new(res.inspect)
        end
      end
      
      def handle_error(e)
        logger.error "#{Time.now} ERROR\n#{e.message}" if logger
        raise SteamFi::SteamException.new(e.message)      
      end
    end  
  end
end