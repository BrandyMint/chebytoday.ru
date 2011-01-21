require 'test_helper'

class BlogSourceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BlogSource.new.valid?
  end
end
