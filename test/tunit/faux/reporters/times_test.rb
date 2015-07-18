require "test_helper"
require "tunit/faux/reporters/times"
require "tunit/mock"

module Tunit::Faux::Reporters
  class TimesTest < Minitest::Test
    def test_run
      mock = Tunit::Mock.new(:spy)
      reporter = Times.new(method_name: :foo, times: 1, mock: mock)

      mock.foo

      assert reporter.run
    end

    def test_run_on_violation
      mock = Tunit::Mock.new(:spy)
      reporter = Times.new(method_name: :foo, times: 1, mock: mock)

      mock.foo
      mock.foo

      refute reporter.run
    end

    def test_result_on_failure
      mock = Tunit::Mock.new(:spy)
      reporter = Times.new(method_name: :foo, times: 1, mock: mock)

      mock.foo
      mock.foo

      exp_report = <<-EOS
        Expected Tunit::Mock::Spy#foo[] to have been called 1 time, was called 2 times
      EOS

      assert_equal exp_report.strip, reporter.report
    end
  end
end
