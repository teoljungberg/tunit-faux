require "tunit/faux/reporters/base"

module Tunit
  module Faux
    module Reporters
      class Arguments < Base
        def run
          mock.calls.any? do |call|
            same_arguments?(call) || same_argument_type?(call)
          end
        end

        def report
          if violation?
            "#{base_message}, was called with #{violating_call.arguments}"
          end
        end

        private

        def violation?
          run == false
        end

        def violating_call
          mock.calls.first || NullCall.new
        end

        def same_arguments?(call)
          call.arguments == arguments
        end

        def same_argument_type?(call)
          call.arguments.any? && call.arguments.all? do |argument|
            argument.class.ancestors.include?(arguments.first)
          end
        end

        class NullCall
          def arguments
            []
          end
        end
        private_constant :NullCall
      end
    end
  end
end
