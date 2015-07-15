require "tunit/faux/reporters"

module Tunit
  module Faux
    class Settler
      attr_reader :mock, :method_name, :arguments, :times

      def initialize(mock: nil, method_name: nil, arguments: [], times: 1)
        @mock = mock
        @method_name = method_name
        @arguments = Array(arguments)
        @times = times
      end

      def satisfied?
        reporters.all?(&:run)
      end

      def reason
        reporters.
          map(&:report).
          compact.
          first
      end

      private

      def reporters
        @reporters ||= [
          Reporters::MethodName.new(
            method_name: method_name,
            mock: mock,
          ),
          Reporters::Arguments.new(
            method_name: method_name,
            arguments: arguments,
            mock: mock,
          ),
          Reporters::Times.new(
            method_name: method_name,
            times: times,
            mock: mock,
          ),
        ]
      end
    end
  end
end
