require "test_helper"
require "tunit/settler"
require "tunit/mock"

module Tunit
  class SettlerTest < Minitest::Test
    def setup
      @mock = Mock.new
    end
    attr_reader :mock

    def test_mock
      settler = Settler.new mock: mock

      assert_equal mock, settler.mock
    end

    def test_method_name
      settler = Settler.new method_name: :foo

      assert_equal :foo, settler.method_name
    end

    def test_arguments
      settler = Settler.new arguments: 2

      assert_equal 2, settler.arguments
    end

    def test_times
      settler = Settler.new times: 2

      assert_equal 2, settler.times
    end

    def test_times_fallback
      settler = Settler.new

      assert_equal 1, settler.times
    end

    def test_satisfied_eh_method_name
      settler = Settler.new mock: mock, method_name: :foo

      mock.foo

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_arguments
      settler = Settler.new mock: mock, method_name: :foo, arguments: 1

      mock.foo(1)

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_times
      settler = Settler.new mock: mock, method_name: :foo, arguments: 1, times: 2

      mock.foo(1)
      mock.foo(1)

      assert_predicate settler, :satisfied?
    end

    def test_satisfied_eh_fail_wrong_method_name
      settler = Settler.new mock: mock, method_name: :bar

      mock.foo

      refute_predicate settler, :satisfied?
    end

    def test_satisfied_eh_fail_wrong_arguments
      settler = Settler.new mock: mock, method_name: :foo, arguments: :no

      mock.foo(1)

      refute_predicate settler, :satisfied?
    end

    def test_satisfied_eh_fail_wrong_times
      settler = Settler.new mock: mock, method_name: :foo, arguments: 1, times: 2

      mock.foo(1)
      mock.foo(1)
      mock.foo(1)

      refute_predicate settler, :satisfied?
    end
  end
end
