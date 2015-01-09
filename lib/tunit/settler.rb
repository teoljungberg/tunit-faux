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
      match_method && match_arguments
    end

    def reason
      build_message
    end

    private

    def build_message
      message = ""

      unless match_method
        message += "Expected #{mock.class}##{method_name} "
      end

      unless match_arguments
        message += "to have been called with #{arguments}"
      end

      message
    end

    def match_method
      count = matched_methods.reduce(0) { |counter, mock|
        counter += 1 if mock.method_name == method_name
      }

      count == times
    end

    def match_arguments
      matched_methods.any? { |mock|
        mock.arguments.include? arguments or
          arguments.first === mock.arguments.first or
          arguments == mock.arguments
      }
    end

    def matched_methods
      mock.calls.select { |mock|
        mock.method_name == method_name
      }
    end
  end
end
