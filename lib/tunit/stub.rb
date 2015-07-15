module Tunit
  class Stub
    def self.stub(object, method_name, return_value)
      aliased_method_name = "__temporary_stub_#{method_name}__"

      if block_given?
        instance = new(aliased_method_name)
        instance.stub(object, method_name, return_value)

        yield

        instance.unstub(object, method_name)
      end
    end

    def initialize(aliased_method_name)
      @aliased_method_name = aliased_method_name
      @stubs = {}
    end

    def stub(object, method_name, return_value)
      metaklass = (class << object; self; end)

      metaklass.send :alias_method, @aliased_method_name, method_name

      metaklass.send :define_method, method_name do |*args, &blk|
        blk.call(*args) if blk

        if return_value.respond_to? :call
          return_value.call(*args)
        else
          return_value
        end
      end
    end

    def unstub(object, method_name)
      metaklass = (class << object; self; end)
      metaklass.send :undef_method, method_name
      metaklass.send :alias_method, method_name, @aliased_method_name
      metaklass.send :undef_method, @aliased_method_name
    end
  end
end
