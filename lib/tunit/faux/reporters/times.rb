module Tunit
  module Faux
    module Reporters
      class Times
        attr_reader :method_name, :times, :mock

        def initialize(method_name:, times:, mock:)
          @method_name = method_name
          @times = times
          @mock = mock
        end

        def run
          number_of_invocations == times
        end

        def report
          if violation?
            "Expected #{mock.class}##{method_name} to have been called " +
              "#{times} #{pluralize_times(times)}, " +
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
          if count > 1
            "times"
          else
            "time"
          end
        end
      end
    end
  end
end
