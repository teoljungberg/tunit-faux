require "test_helper"
require "tunit/faux/reporters/method_name"
require "tunit/mock"

module Tunit::Faux::Reporters
  class MethodNameTest < Minitest::Test
    def test_run
      mock = Tunit::Mock.new(:spy)
      reporter = MethodName.new(
        method_name: :foo,
        mock: mock,
      )

      mock.foo

      assert reporter.run
    end

    def test_run_verifies_that_target_was_called_on_mock
      mock = Tunit::Mock.new(:spy)
      reporter = MethodName.new(method_name: :foo, mock: mock)

      mock.bar

      refute reporter.run
    end

    def test_report
      mock = Tunit::Mock.new(:spy)
      reporter = MethodName.new(method_name: :foo, mock: mock)

      mock.bar

      exp_report = <<-EOS
        Expected Tunit::Mock::Spy#foo[] to have been called
      EOS

      assert_equal exp_report.strip, reporter.report
    end
  end
end
