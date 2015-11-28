require "test_helper"
require "tunit/mock"

module Tunit
  class MockTest < Minitest::Test
    def test_new
      mock = Mock.new

      assert_instance_of Mock::Double, mock
    end

    def test_new_with_arguments
      mock = Mock.new(nil, "name")

      assert_equal "name", mock.name
      assert_instance_of Mock::Double, mock
    end

    def test_new_unsupported_types
      mock = Mock.new(:unsupported_type)

      assert_instance_of Mock::Double, mock
    end

    def test_new_null_object
      mock = Mock.new(:null_object)

      assert_instance_of Mock::NullObject, mock
    end

    def test_new_spy
      mock = Mock.new(:spy)

      assert_instance_of Mock::Spy, mock
    end
  end
end
