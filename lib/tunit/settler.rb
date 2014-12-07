module Tunit
  class Settler
    attr_reader :mock, :method_name, :arguments, :times

    def initialize mock: nil, method_name: nil, arguments: [], times: 1
      @mock = mock
      @method_name = method_name
      @arguments = Array(arguments)
      @times = times
    end

    def satisfied?
      method_matches? && arguments_matches?
    end

    private

    def method_matches?
      count = matched_methods.reduce(0) { |counter, mock|
        counter += 1 if mock.method_name == method_name
      }

      count == times
    end

    def arguments_matches?
      matched_methods.any? { |mock|
        mock.arguments.include? arguments or
          mock.arguments == arguments
      }
    end

    def matched_methods
      mock.calls.select { |mock|
        mock.method_name == method_name
      }
    end
  end
end
