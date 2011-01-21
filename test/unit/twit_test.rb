require 'test_helper'

class TwitTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Twit.new.valid?
  end
end
