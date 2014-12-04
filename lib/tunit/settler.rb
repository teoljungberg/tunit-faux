module Tunit
  class Settler
    attr_reader :mock, :method_name, :arguments, :times

    def initialize mock: nil, method_name: nil, arguments: [], times: 1
      @mock = mock
      @method_name = method_name
      @arguments = arguments
      @times = times
    end

    def satisfied?
      method_matches? && arguments_matches?
    end

    private

    def method_matches?
      count = mock.calls.reduce(0) { |counter, mock|
        counter += 1 if mock.method_name == method_name
      }

      count == times
    end

    def arguments_matches?
      mock.calls.any? { |mock|
        mock.arguments.include? arguments or
          mock.arguments == arguments
      }
    end
  end
end
