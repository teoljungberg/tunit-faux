require "test_helper"
require "tunit/faux"

module Integration
  class MockTest < Minitest::Test
    def test_integration_mock
      test_klass = Class.new(Minitest::Test) do
        def test_mock
          mock
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_mock)

      assert test_case.passed?
    end

    def test_integration_mock_with_name
      test_klass = Class.new(Minitest::Test) do
        def test_mock
          greeter = mock("Greeter")

          assert_equal "Greeter", greeter.name
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_mock)

      assert test_case.passed?
    end

    def test_integration_spy
      test_klass = Class.new(Minitest::Test) do
        def test_spy
          spy
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_spy)

      assert test_case.passed?
    end

    def test_integration_spy_with_name
      test_klass = Class.new(Minitest::Test) do
        def test_spy
          greeter = spy("Greeter")

          assert_equal "Greeter", greeter.name
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_spy)

      assert test_case.passed?
    end

    def test_integration_double
      test_klass = Class.new(Minitest::Test) do
        def test_double
          double
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_double)

      assert test_case.passed?
    end

    def test_integration_double_with_name
      test_klass = Class.new(Minitest::Test) do
        def test_double
          greeter = double("Greeter")

          assert_equal "Greeter", greeter.name
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_double)

      assert test_case.passed?
    end

    def test_integration_double_name_with_stubs
      test_klass = Class.new(Minitest::Test) do
        def test_double
          greeter = double("Greeter", foo: 1)

          assert_equal "Greeter", greeter.name
          assert_equal 1, greeter.foo
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_double)

      assert test_case.passed?
    end

    def test_integration_double_with_only_stubs
      test_klass = Class.new(Minitest::Test) do
        def test_double
          greeter = double(foo: 1)

          assert_equal "anonymous", greeter.name
          assert_equal 1, greeter.foo
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_double)

      assert test_case.passed?
    end
  end

  class StubTest < Minitest::Test
    def test_integration_stub
      test_klass = Class.new(Minitest::Test) do
        def test_stub
          animal = "cat"

          test_case = self
          stub(animal, :upcase, "Tiger") do
            test_case.assert_equal "Tiger", animal.upcase
          end
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_stub)

      assert test_case.passed?
      assert_equal 1, test_case.assertions
    end
  end

  class AssertionTest < Minitest::Test
    def test_integration_assertions
      test_klass = Class.new(Minitest::Test) do
        def test_assertion
          greeter = spy

          greeter.greet("world")

          assert_received greeter, :greet, with: "world"
        end

        def test_refution
          greeter = spy

          greeter.greet("bye")

          refute_received greeter, :greet, with: "world"
        end
      end
      test_case_assertion = Minitest.run_one_method(
        test_klass,
        :test_assertion,
      )
      test_case_refution = Minitest.run_one_method(
        test_klass,
        :test_refution,
      )

      assert test_case_assertion.passed?
      assert test_case_refution.passed?
    end

    def test_integration_assertions_failure
      test_klass = Class.new(Minitest::Test) do
        def test_assertions
          greeter = spy

          greeter.greet("bye")

          assert_received greeter, :greet, with: "world"
        end
      end
      test_case = Minitest.run_one_method(test_klass, :test_assertions)

      exp_message = <<~EOS
        Expected Spy(anonymous)#greet["world"] to have been called, was called with ["bye"]
      EOS
      refute test_case.passed?
      assert_equal exp_message.strip, test_case.failure.error.to_s
    end
  end
end
