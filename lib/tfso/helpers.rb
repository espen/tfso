module TFSO

  module Helpers
    def intialize_savon_client
      @savon_client = Savon.client(wsdl: self.class::URL, convert_request_keys_to: :none)
      if defined?(Rails) && Rails.env.development?
        @savon_client.globals.proxy('http://localhost:8080')
        @savon_client.globals.ssl_verify_mode(:none)
      end
      @savon_client.globals.unwrap(true)
    end

    def savon_client
      @savon_client
    end

    def session_id
      @session_id
    end

    def session_id=(session_id)
      @session_id = session_id
      @cookies = [HTTPI::Cookie.new("ASP.NET_SessionId=#{@session_id}")]
    end
  end

end