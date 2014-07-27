require "test_helper"
remove_minitest_stub_definition!
require "tunit/stub"

class StubTest < Minitest::Test
  def setup
    @obj = Object.new
  end
  attr_reader :obj

  def test_stub_only_stubs_already_defined_methods
    obj.class.send :define_method, :foo, -> { 42 }

    tc = self

    obj.stub :foo, 1337 do
      tc.assert_equal 1337, obj.foo
    end
  end

  def test_stub_raises_hell_if_trying_to_stub_an_undefined_method
    refute_respond_to obj, :bar

    e = assert_raises NameError do
      obj.stub :bar, 1337 do end
    end

    assert_equal "undefined method `bar' for class `Object'", e.message
  end
end
