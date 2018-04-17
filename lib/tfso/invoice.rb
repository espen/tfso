module TFSO
  class Invoice

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/Economy/InvoiceOrder/V001/InvoiceService.asmx?wsdl'

    def initialize(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def find(search_params)
      response = savon_client.call(:get_invoices, message: {searchParams: search_params, invoiceReturnProperties: {string: ['OrderId', 'InvoiceId', 'CustomerId', 'OrderStatus', 'DateOrdered', 'DateInvoiced', 'PaymentTime', 'CustomerReferenceNo', 'IncludeVAT', 'YourReference', 'OrderTotalIncVat', 'OrderTotalVat', 'InvoiceTitle', 'InvoiceText', 'Paid', 'Currency', 'PaymentMethodId', 'PaymentAmount', 'TypeOfSaleId', 'Distributor', 'DistributionMethod', 'InvoiceEmailAddress']}, rowReturnProperties: {string: ['ProductId', 'VatRate', 'Price', 'Name', 'DiscountRate', 'Quantity']} }, cookies: @cookies)
      result = response.body[:get_invoices_response][:get_invoices_result]
      if result
        if result[:invoice_order].class == Hash
          [result[:invoice_order]]
        else
          result[:invoice_order]
        end
      else
        []
      end
    end

    def find_by_invoice_id(id)
      if invoice = find(InvoiceIds: {int: [id]})
        invoice.first
      else
        false
      end
    end

    def find_by_order_id(id)
      if invoice = find(OrderIds: {int: [id]})
        invoice.first
      else
        false
      end
    end

    def create(invoice, items)
      response = savon_client.call(:save_invoices, message: {invoices: [{InvoiceOrder: transform_attributes(invoice, items) }] }, cookies: @cookies)
      response.body[:save_invoices_response][:save_invoices_result][:invoice_order]
    end

    private

    def transform_attributes(invoice, items)
      state = case invoice[:state]
      when :invoice
        'Invoiced'
      when :draft
        'Offer'
      else
        invoice[:state]
      end
      invoice_info = {
        OrderStatus: state,
        DateOrdered: Time.zone.today.iso8601,
        CustomerId: invoice[:customer_id],
        CustomerName: invoice[:customer_name],
        CustomerOrgNo: invoice[:customer_gov_no],
        InvoiceEmailAddress: invoice[:customer_email],
        InvoiceRows: []
      }
      invoice_info[:TypeOfSaleId] = invoice[:type_of_sale_id]
      invoice_info[:PaymentTime] = invoice[:payment_time]
      if invoice[:currency]
        invoice_info[:Currency] = {
          Symbol: invoice[:currency],
          Rate: invoice[:currency_rate].to_f,
        }
      end
      invoice_info[:InvoiceTitle] = invoice[:title] if invoice[:title]
      invoice_info[:InvoiceText] = invoice[:description] if invoice[:description]
      invoice_info[:YourReference] = invoice[:order_ref]

      invoice_info[:Distributor] = invoice[:distributor] if invoice[:distributor]
      invoice_info[:DistributionMethod] = invoice[:distribution_method] if invoice[:distribution_method]

      invoice[:Addresses] = {
        Invoice: {
          :Street => invoice[:customer_street],
          :PostalCode => invoice[:customer_postal_code],
          :PostalArea => invoice[:customer_city],
          :State => invoice[:customer_state],
          :Country => invoice[:customer_country_code]
        }
      }
      if items.any?
        invoiceRows = []
        items.each {|item|
          invoiceRows << {
            ProductId: item[:product_id],
            Name: item[:description],
            Price: item[:price].to_f,
            Quantity: item[:quantity].to_f
          }
        }
        invoice_info[:InvoiceRows] = { :InvoiceRow => invoiceRows }
      end
      invoice_info
    end

  end
end