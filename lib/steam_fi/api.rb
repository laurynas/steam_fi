require 'net/http'
require 'uri'

module SteamFi
  class API
    # Default configuration 
    @@config = {
      :sms_url  => 'https://pipe.steam.fi/contentbroker/api/sendsms',
      :username => nil,
      :password => nil
    }
    
    cattr_accessor :logger
    
    # Logger
    @@logger = Logger.new File.join(RAILS_ROOT, '/log/', "steam_fi_#{RAILS_ENV}.log")
    
    # Set configuration parameters
    def self.setup(options)
      @@config.merge!(options)
    end
    
    # Send SMS message
    def self.send_sms(msisdn, message, params = {})
      params.merge! :msisdn => msisdn, :msg => message
      self.request @@config[:sms_url], params
    end
    
    protected
    
    # Send request
    def self.request(url, params = {})
      # add username & password
      params.merge! :l => @@config[:username], :p => @@config[:password]
      
      @@logger.info "#{Time.now} REQUEST\n#{url}\n#{params.to_yaml}"

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
        self.handle_error e
      end
        
      case res
      when Net::HTTPSuccess
        @@logger.info "#{Time.now} RESPONSE\n#{res.body}"
        res.body
      else
        self.handle_error SteamFi::SteamException.new(res.inspect)
      end
    end
    
    def self.handle_error(e)
      @@logger.error "#{Time.now} ERROR\n#{e.message}"
      raise SteamFi::SteamException.new(e.message)      
    end
  end
end