module TFSO
  class Client

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/Client/V001/ClientService.asmx?WSDL'

    def initialize(auth)
      ensure_authenticated(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def type_groups(module_type)
      response = savon_client.call(:get_type_group_list, message: {module_type: module_type}, cookies: @cookies)
      response.body[:get_type_group_list_response][:get_type_group_list_result]
    end

  end
end