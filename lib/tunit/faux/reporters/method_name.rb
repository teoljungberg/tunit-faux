module Tunit
  module Faux
    module Reporters
      class MethodName
        attr_reader :method_name, :mock

        def initialize(method_name:, mock:)
          @method_name = method_name
          @mock = mock
        end

        def run
          mock.calls.any? do |call|
            call.method_name == method_name
          end
        end

        def report
          if violation?
            "Expected #{mock.class}##{method_name} to have been called"
          end
        end

        private

        def violation?
          run == false
        end
      end
    end
  end
end
