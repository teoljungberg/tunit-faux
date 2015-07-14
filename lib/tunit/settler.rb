module Tunit
  class Settler
    attr_reader :mock, :method_name, :arguments, :times

    def initialize(mock: nil, method_name: nil, arguments: [], times: 1)
      @mock = mock
      @method_name = method_name
      @arguments = Array(arguments)
      @times = times
    end

    def satisfied?
      matched_method_name? &&
        matched_arguments? &&
        matched_number_of_invocations?
    end

    def reason
      message = ""

      if !matched_method_name?
        message += "Expected #{mock.class}##{method_name} to have been called"
      end

      if matched_method_name? && !matched_arguments?
        actual_call = mock.calls.first
        message += "Expected #{mock.class}##{method_name} to have been called "
        message += "with #{arguments.inspect}, was called with #{actual_call.arguments.inspect}"
      end

      if matched_method_name? && !matched_number_of_invocations?
        actual_call = mock.calls.first
        message += "Expected #{mock.class}##{method_name} to have been called "
        message += "#{times} #{pluralize_times(times)}"
        message += ", was called #{matched_number_of_invocations} #{pluralize_times(matched_number_of_invocations)}"
      end

      message
    end

    private

    def matched_method_name?
      mock.calls.any? do |call|
        call.method_name == method_name
      end
    end

    def matched_arguments?
      mock.calls.any? do |call|
        same_arguments?(call) || same_type?(call)
      end
    end

    def same_arguments?(call)
      arguments == call.arguments
    end

    def same_type?(call)
      arguments.first === call.arguments.first
    end

    def matched_number_of_invocations?
      times == matched_number_of_invocations
    end

    def matched_number_of_invocations
      mock.calls.reduce(0) { |counter, call|
        counter = counter.succ if method_name == call.method_name
      }
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
