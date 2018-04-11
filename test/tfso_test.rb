require "test_helper"

class TFSOTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TFSO::VERSION
  end
end