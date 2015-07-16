require "tunit/faux/reporters"

module Tunit
  module Faux
    class Settler
      attr_reader :arguments, :method_name, :times, :mock

      def initialize(arguments: [], method_name:, mock:, times: 1)
        @arguments = Array(arguments)
        @method_name = method_name
        @mock = mock
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
          Reporters::MethodName,
          Reporters::Arguments,
          Reporters::Times,
        ].map do |reporter_klass|
          reporter_klass.new(
            arguments: arguments,
            method_name: method_name,
            mock: mock,
            times: times,
          )
        end
      end
    end
  end
end
