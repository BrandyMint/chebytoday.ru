require 'test_helper'

class PoliticTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Politic.new.valid?
  end
end
