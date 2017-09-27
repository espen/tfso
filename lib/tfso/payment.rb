module TFSO
  class Payment

    include TFSO::Helpers

    URL = 'https://api.24sevenoffice.com/Economy/InvoiceOrder/V001/PaymentService.asmx?WSDL'

    def initialize(auth)
      self.session_id = auth.session_id
      intialize_savon_client
    end

    def create(payment_info)
      response = savon_client.call(:register_invoice_payment, message: {payment: payment_info }, cookies: @cookies)
      response.body[:register_invoice_payment_response][:register_invoice_payment_result]
    end

  end
end