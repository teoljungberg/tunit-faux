require "test_helper"
require "tunit/mock/double"

module Tunit::Mock
  class DoubleTest < Minitest::Test
    def test_initialize_with_incorrect_data
      double = Double.new([])

      assert_equal({}, double.expected_methods)
    end

    def test_method_missing
      double = Double.new(foo: nil)

      double.foo
      double.foo

      assert_equal 2, double.calls.size
    end

    def test_method_missing_white_listed_method
      double = Double.new(foo: 1, bar: 2, baz: 3)

      assert_equal 1, double.foo
      assert_equal 2, double.bar
      assert_equal 3, double.baz
    end

    def test_method_missing_blacklisted_method
      double = Double.new(foo: 1)

      e = assert_raises Double::UnexpectedMethod do
        double.bar
      end

      assert_equal "`bar' was not expected to be called", e.message
    end

    def test_inspect_with_whitelisted_methods
      double = Double.new("mocked_user", foo: 1)

      assert_equal "Double(mocked_user)", double.inspect
    end
  end
end
