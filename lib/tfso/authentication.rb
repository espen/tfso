module TFSO

  class Authentication

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/authenticate/v001/authenticate.asmx?wsdl'

    attr_accessor :application_id

    def initialize(application_id)
      @application_id = application_id
      intialize_savon_client
    end

    def authenticated?
      response = savon_client.call(:has_session, cookies: @cookies )
      response.body[:has_session_response][:has_session_result]
    end

    def authenticate(username, password, identity_id = nil)
      response = savon_client.call(:login, message: { credential: {Username: username, Password: password, IdentityId: identity_id, ApplicationId: application_id} })
      self.session_id = response.body[:login_response][:login_result]
    end

    def identities
      response = savon_client.call(:get_identities, cookies: @cookies )
      response.body[:get_identities_response][:get_identities_result].first.last
    end

    def identity_id
      response = savon_client.call(:get_identity, cookies: @cookies)
      response.body[:get_identity_response][:get_identity_result][:id]
    end

    def identity_id=(identity_id)
      response = savon_client.call(:set_identity_by_id, message: {identityId: identity_id}, cookies: @cookies)
      @identity_id = identity_id
    end

  end

end