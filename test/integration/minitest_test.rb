require "test_helper"
require "tunit/faux"

module Integration
  class MinitestTest
    class MockTest < Minitest::Test
      def test_integration_mock
        test_klass = Class.new(Minitest::Test) do
          def test_mock
            assert_equal "anonymous", mock.name
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
            assert_equal "anonymous", spy.name
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
            assert_equal "anonymous", double.name
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

            greeter.greet

            assert_received greeter, :greet
          end

          def test_assertion_with_arguments
            greeter = spy

            greeter.greet("world")

            assert_received greeter, :greet, with: "world"
          end

          def test_assertion_with_times
            greeter = spy

            greeter.greet("world")
            greeter.greet("world")

            assert_received greeter, :greet, times: 2, with: "world"
          end

          def test_refution
            greeter = spy

            refute_received greeter, :greet
          end

          def test_refution_with_arguments
            greeter = spy

            greeter.greet("hello")

            refute_received greeter, :greet, with: "world"
          end

          def test_refution_with_times
            greeter = spy

            greeter.greet("world")
            greeter.greet("world")

            refute_received greeter, :greet, times: 1, with: "world"
          end
        end
        test_case_assertion = Minitest.run_one_method(
          test_klass,
          :test_assertion,
        )
        test_case_assertion_with_arguments = Minitest.run_one_method(
          test_klass,
          :test_assertion_with_arguments,
        )
        test_case_assertion_with_times = Minitest.run_one_method(
          test_klass,
          :test_assertion_with_times,
        )
        test_case_refution = Minitest.run_one_method(
          test_klass,
          :test_refution,
        )
        test_case_refution_with_arguments = Minitest.run_one_method(
          test_klass,
          :test_refution_with_arguments,
        )
        test_case_refution_with_times = Minitest.run_one_method(
          test_klass,
          :test_refution_with_times,
        )

        assert test_case_assertion.passed?
        assert test_case_assertion_with_arguments.passed?
        assert test_case_assertion_with_times.passed?
        assert test_case_refution.passed?
        assert test_case_refution_with_arguments.passed?
        assert test_case_refution_with_times.passed?
      end

      def test_integration_assertions_failure
        test_klass = Class.new(Minitest::Test) do
          def test_refution
            greeter = spy

            assert_received greeter, :greet
          end

          def test_refution_with_arguments
            greeter = spy

            greeter.greet("hello")

            assert_received greeter, :greet, with: "world"
          end

          def test_refution_with_times
            greeter = spy

            greeter.greet("world")
            greeter.greet("world")

            assert_received greeter, :greet, times: 1, with: "world"
          end
        end
        test_case_refution = Minitest.run_one_method(
          test_klass,
          :test_refution,
        )
        test_case_refution_with_arguments = Minitest.run_one_method(
          test_klass,
          :test_refution_with_arguments,
        )
        test_case_refution_with_times = Minitest.run_one_method(
          test_klass,
          :test_refution_with_times,
        )

        exp_message = <<~EOS
          Expected Spy(anonymous)#greet[] to have been called
        EOS
        refute test_case_refution.passed?
        assert_equal exp_message.strip, test_case_refution.failure.error.to_s

        exp_message = <<~EOS
          Expected Spy(anonymous)#greet["world"] to have been called, was called with ["hello"]
        EOS
        refute test_case_refution_with_arguments.passed?
        assert_equal(
          exp_message.strip,
          test_case_refution_with_arguments.failure.error.to_s,
        )

        exp_message = <<~EOS
          Expected Spy(anonymous)#greet["world"] to have been called 1 time, was called 2 times
        EOS
        refute test_case_refution_with_times.passed?
        assert_equal(
          exp_message.strip,
          test_case_refution_with_times.failure.error.to_s,
        )
      end
    end
  end
end
