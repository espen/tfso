module TFSO
  class Company

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/CRM/Company/V001/CompanyService.asmx?wsdl'

    def initialize(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def find(search_params)
      response = savon_client.call(:get_companies, message: {searchParams: search_params, returnProperties: {string: ['Id', 'OrganizationNumber', 'NickName', 'Country', 'Addresses', 'EmailAddresses', 'PhoneNumbers', 'InvoiceLanguage', 'TypeGroup', 'DistributionMethod', 'Currency'] } }, cookies: @cookies)
      result = response.body[:get_companies_response][:get_companies_result]
      if result
        if result[:company].class == Hash
          [result[:company]]
        else
          result[:company]
        end
      else
        []
      end
    end

    def find_by_id(id)
      if company = find(CompanyId: id)
        company.first
      end
    end

    def find_by_name(name)
      find(CompanyName: name)
    end

    def create(company_info)
      response = savon_client.call(:save_companies, message: {companies: [{Company: company_info}] }, cookies: @cookies)
      result = response.body[:save_companies_response][:save_companies_result]
      if result
        if result[:company].class == Hash
          if result[:company][:api_exception]
            raise "Error when saving tfso company"
          else
            result[:company]
          end
        else
          result[:company]
        end
      else
        false
      end
    end

    def transform_attributes(company)
      company.compact!
      company[:EmailAddresses] ||= []
      company[:PhoneNumbers] ||= []
      company[:Addresses] ||= []
      if company[:billing_id]
        company[:id] = company.delete(:billing_id)
      else
        company[:Type] = 'Business'
      end
      if company[:billing_name]
        company[:nickname] = company.delete(:name)
        company[:name] = company.delete(:billing_name)
      end
      if company[:billing_email]
        company[:EmailAddresses] << {:Invoice => {
            :Value => company.delete(:billing_email)
          }
        }
        company.delete(:billing_email)
      end
      if company[:email]
        company[:EmailAddresses] << {:Work => {
            :Value => company.delete(:email)
          }
        }
        company.delete(:email)
      end
      if company[:phone_number]
        company[:PhoneNumbers] << {:Work => {
            :Value => company.delete(:phone_number)
          }
        }
        company.delete(:phone_number)
      end
      if company[:mobile_phone_number]
        company[:PhoneNumbers] << {:Mobile => {
            :Value => company.delete(:mobile_phone_number)
          }
        }
        company.delete(:mobile_phone_number)
      end
      if company[:billing_address]
        address = {
          :Name => company.delete(:billing_name) || company[:name],
          :Street => company.delete(:billing_street),
          :PostalCode => company.delete(:billing_postal_code),
          :PostalArea => company.delete(:billing_city),
          :State => company.delete(:billing_state),
          :Country => company.delete(:billing_country_code)
        }
        company[:Addresses] << {:Invoice => address}
        company[:Addresses] << {:Delivery => address.merge(:Name => company[:name])}

        company.delete(:billing_address)
      end
      if company[:tfso]
        company[:tfso].keys.each{|k| company[k] = company[:tfso].delete(k) }
        company.delete(:tfso)
      end

      mappings = {:name => :Name, :nickname => :NickName, :gov_no => :OrganizationNumber, :country_code => :Country}

      company.keys.each { |k| company[ mappings[k] ] = company.delete(k) if mappings[k] }
      company
    end

  end
end