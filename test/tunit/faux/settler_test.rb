require "test_helper"
require "tunit/faux/settler"
require "tunit/mock"

module Tunit::Faux
  class SettlerTest < Minitest::Test
    def test_satisfied_eh_method_name
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo)

      mock.foo

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_arguments
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: 1)

      mock.foo(1)

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_arguments_by_type
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: String)

      mock.foo("whatever")

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_times
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, times: 2)

      mock.foo
      mock.foo

      assert_predicate settler, :satisfied?
    end

    def test_reason_method_name
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo)

      mock.bar

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo[] to have been called
      EOS

      assert_equal exp_message.strip, settler.reason.strip
    end

    def test_reason_arguments
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, arguments: 1)

      mock.foo(2)

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo[1] to have been called, was called with [2]
      EOS

      assert_equal exp_message.strip, settler.reason.strip
    end

    def test_reason_times
      mock = Tunit::Mock.new
      settler = Settler.new(mock: mock, method_name: :foo, times: 2)

      mock.foo

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo[] to have been called 2 times, was called 1 time
      EOS

      assert_equal exp_message.strip, settler.reason.strip
    end

    def test_reason_times_with_arguments
      mock = Tunit::Mock.new
      settler = Settler.new(
        arguments: 1,
        method_name: :foo,
        mock: mock,
        times: 2,
      )

      mock.foo(1)
      mock.foo(1)
      mock.foo(1)

      refute_predicate settler, :satisfied?

      exp_message = <<-EOS.strip_heredoc
        Expected Tunit::Mock#foo[1] to have been called 2 times, was called 3 times
      EOS

      assert_equal exp_message.strip, settler.reason.strip
    end
  end
end
