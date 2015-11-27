require "tunit/faux/settler"
require "tunit/mock"

module Minitest
  module Assertions
    def assert_received(mock, method_name, args = {})
      arguments = args[:with] ? [args[:with]] : []
      times = args[:times] ? args[:times] : 1
      settler = Tunit::Faux::Settler.new(
        method_name: method_name,
        mock: mock,
        arguments: arguments,
        times: times,
      )

      assert settler.satisfied?, settler.reason
    end

    def refute_received(mock, method_name, args = {})
      arguments = args[:with] ? [args[:with]] : []
      times = args[:times] ? args[:times] : 1
      settler = Tunit::Faux::Settler.new(
        method_name: method_name,
        mock: mock,
        arguments: arguments,
        times: times,
      )

      refute settler.satisfied?, settler.reason
    end
  end

  class Test
    def stub(object, method_name, return_value, &block)
      Tunit::Stub.stub(object, method_name, return_value, &block)
    end

    def mock(*args)
      Tunit::Mock.new(nil, args)
    end

    def spy(*args)
      Tunit::Mock.new(:spy, args)
    end

    def double(*args)
      Tunit::Mock.new(:double, args)
    end
  end
end
