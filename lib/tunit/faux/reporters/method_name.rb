require "tunit/faux/reporters/base"

module Tunit
  module Faux
    module Reporters
      class MethodName < Base
        def run
          mock.calls.any? do |call|
            call.method_name == method_name
          end
        end

        def report
          if violation?
            base_message.strip
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
