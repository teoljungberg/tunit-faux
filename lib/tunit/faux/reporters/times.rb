require "tunit/faux/reporters/base"

module Tunit
  module Faux
    module Reporters
      class Times < Base
        def run
          number_of_invocations == times
        end

        def report
          if violation?
            base_message +
              " #{times} #{pluralize_times(times)}, " +
              "was called " +
              "#{number_of_invocations} #{pluralize_times(number_of_invocations)}"
          end
        end

        private

        def number_of_invocations
          mock.calls.reduce(0) do |counter, call|
            if call.method_name == method_name
              counter += 1
            else
              counter
            end
          end
        end

        def violation?
          run == false
        end

        def pluralize_times(count)
          if count > 1 || count.zero?
            "times"
          else
            "time"
          end
        end
      end
    end
  end
end
