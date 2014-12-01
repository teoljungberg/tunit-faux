require "test_helper"
require "tunit/mock"

module Tunit
  class MockTest < Minitest::Test
    def setup
      @mock = Mock.new
    end
    attr_reader :mock

    def test_name
      mock = Mock.new name: :my_mock

      assert_equal :my_mock, mock.name
    end

    def test_name_fallback
      mock = Mock.new

      assert_equal :mock, mock.name
    end

    def test_calls
      assert_instance_of Array, mock.calls
      assert_empty mock.calls
    end

    def test_method_missing_gathers_calls
      mock.foo(1)
      mock.foo(2)

      assert_equal 2, mock.calls.size
    end

    def test_method_missing_wraps_calls_as_an_object
      mock.foo(1)
      method_call = mock.calls.first

      assert_equal :foo, method_call.method_name
      assert_equal [1], method_call.arguments
      assert_equal method_call.args, method_call.arguments
      assert_instance_of Proc, method_call.block
    end

    def test_method_missing_hides_its_implementation
      assert_nil mock.foo(1)
    end
  end
end
