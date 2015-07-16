module Tunit
  module Faux
    module Reporters
      class Base
        attr_reader :arguments, :mock, :times, :method_name

        def initialize(arguments: [], method_name:, mock:, times: 1)
          @arguments = Array(arguments)
          @method_name = method_name
          @mock = mock
          @times = times
        end

        private

        def base_message
          "Expected #{mock.class}##{method_name}#{arguments} to have been called"
        end
      end
    end
  end
end
