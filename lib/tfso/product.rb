module TFSO
  class Product

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/Logistics/Product/V001/ProductService.asmx?WSDL'

    def initialize(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def find(search_params)
      response = savon_client.call(:get_products, message: {searchParams: search_params, returnProperties: {string: ['Id', 'Name', 'Price'] } }, cookies: @cookies)
      result = response.body[:get_products_response][:get_products_result]
      if result
        if result[:product].class == Hash
          [result[:product]]
        else
          result[:product]
        end
      else
        []
      end
    end

    def find_by_id(id)
      if product = find(Id: id)
        product.first
      end
    end


  end
end