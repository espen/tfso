module TFSO
  class Person

    include TFSO::Helpers

    URL = 'https://webservices.24sevenoffice.com/CRM/Contact/PersonService.asmx?WSDL'

    def initialize(auth)
      ensure_authenticated(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def find(search_params={})
      response = savon_client.call(:get_persons, message: {personSearch: search_params}, cookies: @cookies)
      result = response.body[:get_persons_response][:get_persons_result]
      if result
        if result[:person_item].class == Hash
          [result[:person_item]]
        else
          result[:person_item]
        end
      else
        []
      end
    end

    def create(person_info)
      response = savon_client.call(:save_person, message: {personItem: person_info}, cookies: @cookies)
      result = response.body[:save_person_response][:save_person_result]
      if result
        if result.class == Hash
          if result[:api_exception]
            raise "Error when saving tfso person"
          else
            result
          end
        else
          result
        end
      else
        false
      end
    end

  end
end