require 'test_helper'

class Cat1Test < MiniTest::Unit::TestCase
  def test_export
    assert QrdaGenerator::Export::Cat1.export(nil)
  end
end