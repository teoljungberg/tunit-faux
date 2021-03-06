require "test_helper"
require "tunit/faux"

class MinitestHelper < Minitest::Test
  def build_test_case(&block)
    klass = Class.new(MinitestHelper, &block)
    method_name = klass.runnable_methods.first
    klass.new(method_name).run
  end

  def assert_passed(test_case)
    assert test_case.passed?, test_case.failure
  end

  def refute_passed(test_case)
    refute test_case.passed?, test_case.failure
  end
end

class MockTest < MinitestHelper
  def test_integration_mock
    test_case = build_test_case do
      def test_mock
        assert_equal "anonymous", mock.name
      end
    end

    assert_passed test_case
  end

  def test_integration_mock_with_name
    test_case = build_test_case do
      def test_mock
        greeter = mock("Greeter")

        assert_equal "Greeter", greeter.name
      end
    end

    assert_passed test_case
  end

  def test_integration_spy
    test_case = build_test_case do
      def test_spy
        assert_equal "anonymous", spy.name
      end
    end

    assert_passed test_case
  end

  def test_integration_spy_with_name
    test_case = build_test_case do
      def test_spy
        greeter = spy("Greeter")

        assert_equal "Greeter", greeter.name
      end
    end

    assert_passed test_case
  end

  def test_integration_double
    test_case = build_test_case do
      def test_double
        assert_equal "anonymous", double.name
      end
    end

    assert_passed test_case
  end

  def test_integration_double_with_name
    test_case = build_test_case do
      def test_double
        greeter = double("Greeter")

        assert_equal "Greeter", greeter.name
      end
    end

    assert_passed test_case
  end

  def test_integration_double_name_with_stubs
    test_case = build_test_case do
      def test_double
        greeter = double("Greeter", foo: 1)

        assert_equal "Greeter", greeter.name
        assert_equal 1, greeter.foo
      end
    end

    assert_passed test_case
  end

  def test_integration_double_with_only_stubs
    test_case = build_test_case do
      def test_double
        greeter = double(foo: 1)

        assert_equal "anonymous", greeter.name
        assert_equal 1, greeter.foo
      end
    end

    assert_passed test_case
  end
end

class StubTest < MinitestHelper
  def test_integration_stub
    test_case = build_test_case do
      def test_stub
        animal = "cat"

        test_case = self
        stub(animal, :upcase, "Tiger") do
          test_case.assert_equal "Tiger", animal.upcase
        end
      end
    end

    assert_passed test_case
    assert_equal 1, test_case.assertions
  end
end

class AssertionTest < MinitestHelper
  def test_integration_assertions
    test_case = build_test_case do
      def test_assertion
        greeter = spy

        greeter.greet

        assert_received greeter, :greet
      end
    end

    assert_passed test_case
  end

  def test_integration_assertion_with_arguments
    test_case = build_test_case do
      def test_assertion_with_arguments
        greeter = spy

        greeter.greet("world")

        assert_received greeter, :greet, with: "world"
      end
    end

    assert_passed test_case
  end

  def test_integration_assertion_with_times
    test_case = build_test_case do
      def test_assertion_with_times
        greeter = spy

        greeter.greet("world")
        greeter.greet("world")

        assert_received greeter, :greet, times: 2, with: "world"
      end
    end

    assert_passed test_case
  end

  def test_integration_refution
    test_case = build_test_case do
      def test_refution
        greeter = spy

        refute_received greeter, :greet
      end
    end

    assert_passed test_case
  end

  def test_integration_refution_with_arguments
    test_case = build_test_case do
      def test_refution_with_arguments
        greeter = spy

        greeter.greet("hello")

        refute_received greeter, :greet, with: "world"
      end
    end

    assert_passed test_case
  end

  def test_integration_refution_with_times
    test_case = build_test_case do
      def test_refution_with_times
        greeter = spy

        greeter.greet("world")
        greeter.greet("world")

        refute_received greeter, :greet, times: 1, with: "world"
      end
    end

    assert_passed test_case
  end

  def test_integration_assertions_failure
    test_case = build_test_case do
      def test_refution
        greeter = spy

        assert_received greeter, :greet
      end
    end

    refute_passed test_case
    exp_message = <<~EOS
      Expected Spy(anonymous)#greet[] to have been called
    EOS
    assert_equal exp_message.strip, test_case.failure.error.to_s
  end

  def test_integration_assertions_failure_with_arguments
    test_case = build_test_case do
      def test_refution_with_arguments
        greeter = spy

        greeter.greet("hello")

        assert_received greeter, :greet, with: "world"
      end
    end

    refute_passed test_case
    exp_message = <<~EOS
      Expected Spy(anonymous)#greet["world"] to have been called, was called with ["hello"]
    EOS
    assert_equal exp_message.strip, test_case.failure.error.to_s
  end

  def test_integration_assertions_failure_with_times
    test_case = build_test_case do
      def test_refution_with_times
        greeter = spy

        greeter.greet("world")
        greeter.greet("world")

        assert_received greeter, :greet, times: 1, with: "world"
      end
    end

    refute_passed test_case
    exp_message = <<~EOS
      Expected Spy(anonymous)#greet["world"] to have been called 1 time, was called 2 times
    EOS
    assert_equal exp_message.strip, test_case.failure.error.to_s
  end
end
