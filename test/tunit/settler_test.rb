require "test_helper"
require "tunit/settler"
require "tunit/mock"

module Tunit
  class SettlerTest < Minitest::Test
    def test_mock
      mock = Mock.new
      settler = Settler.new(mock: mock)

      assert_equal mock, settler.mock
    end

    def test_method_name
      settler = Settler.new(method_name: :foo)

      assert_equal :foo, settler.method_name
    end

    def test_arguments
      settler = Settler.new(arguments: 2)

      assert_equal [2], settler.arguments
    end

    def test_times
      settler = Settler.new(times: 2)

      assert_equal 2, settler.times
    end

    def test_times_fallback
      settler = Settler.new

      assert_equal 1, settler.times
    end

    def test_satisfied_eh_method_name
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo)

      mock.foo

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_arguments
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: 1)

      mock.foo(1)

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_arguments_by_type
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: String)

      mock.foo("whatever")

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_times
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, times: 2)

      mock.foo
      mock.foo

      assert_predicate settler, :satisfied?
    end

    def test_reason_method_name
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo)

      mock.bar

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo to have been called
      EOS

      assert_equal exp_message.strip, settler.reason
    end

    def test_reason_arguments
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: 1)

      mock.foo(2)

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo to have been called with [1], was called with [2]
      EOS

      assert_equal exp_message.strip, settler.reason
    end

    def test_reason_times
      mock = Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, times: 2)

      mock.foo

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo to have been called 2 times, was called 1 time
      EOS

      assert_equal exp_message.strip, settler.reason
    end
  end
end
