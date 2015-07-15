require "tunit/mock"

module Tunit
  module Faux
    module Reporters
      class Arguments
        attr_reader :method_name, :arguments, :mock

        def initialize(method_name:, arguments:, mock:)
          @method_name = method_name
          @arguments = Array(arguments)
          @mock = mock
        end

        def run
          mock.calls.any? do |call|
            same_arguments?(call) || same_argument_type?(call)
          end
        end

        def report
          if violation?
            "Expected #{mock.class}##{method_name} to have been called " +
              "with #{arguments.inspect}, " +
              "was called with #{violating_call.arguments.inspect}"
          end
        end

        private

        def violation?
          run == false
        end

        def violating_call
          mock.calls.first
        end

        def same_arguments?(call)
          call.arguments == arguments
        end

        def same_argument_type?(call)
          call.arguments.all? do |argument|
            arguments.first === argument
          end
        end
      end
    end
  end
end
