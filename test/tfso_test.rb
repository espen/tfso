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

end