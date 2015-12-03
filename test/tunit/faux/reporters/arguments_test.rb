require "test_helper"
require "tunit/faux/reporters/arguments"
require "tunit/mock"

module Tunit::Faux::Reporters
  class ArgumentsTest < Minitest::Test
    def test_run_same_arguments
      mock = Tunit::Mock.new(:spy)
      reporter = Arguments.new(method_name: :foo, arguments: [1], mock: mock)

      mock.foo(1)

      assert reporter.run
    end

    def test_run_arguments_of_same_type
      mock = Tunit::Mock.new(:spy)
      reporter = Arguments.new(method_name: :foo, arguments: [Time.now], mock: mock)

      mock.foo

      refute reporter.run
    end

    def test_report_violation
      mock = Tunit::Mock.new(:spy)
      reporter = Arguments.new(method_name: :foo, arguments: [1], mock: mock)

      mock.foo(2)

      exp_report = <<-EOS
        Expected Spy(anonymous)#foo[1] to have been called, was called with [2]
      EOS

      assert_equal exp_report.strip, reporter.report
    end

    def test_report_no_calls
      mock = Tunit::Mock.new(:spy)
      reporter = Arguments.new(method_name: :foo, mock: mock)

      exp_report = <<-EOS
        Expected Spy(anonymous)#foo[] to have been called, was called with []
      EOS

      assert_equal exp_report.strip, reporter.report
    end
  end
end
