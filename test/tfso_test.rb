require "test_helper"

class TFSOTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TFSO::VERSION
  end

  def test_can_get_type_groups
    auth = TFSO::Authentication.new(ENV['TFSO_APPLICATION_ID'])
    auth.authenticate(
      ENV['TFSO_USERNAME'],
      ENV['TFSO_PASSWORD'],
      ENV['TFSO_IDENTITY_ID']
    )
    client = TFSO::Client.new(auth)
    type_groups = client.type_groups('Sale')
    assert !type_groups.empty?
  end

  def test_can_save_company
    auth = TFSO::Authentication.new(ENV['TFSO_APPLICATION_ID'])
    auth.authenticate(
      ENV['TFSO_USERNAME'],
      ENV['TFSO_PASSWORD'],
      ENV['TFSO_IDENTITY_ID']
    )
    company = TFSO::Company.new(auth)
    company_attributes = {
      name: 'Foo Bar',
      billing_address: true,
      billing_name: 'Accounting Bar',
      billing_street: 'Street',
      billing_postal_code: '0559',
      billing_city: 'Paradis',
      billing_state: '',
      billing_country_code: 'NO',
      billing_email: 'example@example.org',
      country_code: 'NO',
      email: 'billing@example.org',
      mobile_phone_number: '99881122',
      tfso: {
        DistributionMethod: 'EMail'
      }
    }
    customer = company.create( company.transform_attributes(company_attributes) )
    assert customer[:id]
  end

end