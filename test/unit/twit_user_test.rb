require 'test_helper'

class TwitUserTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert TwitUser.new.valid?
  end
end
