class Object
  def stub method_name, return_value, &block
    aliased_method_name = "__temporary_stub_#{method_name}__"

    metaklass.send :alias_method, aliased_method_name, method_name

    metaklass.send :define_method, method_name do |*args, &blk|
      blk.call(*args) if blk

      if return_value.respond_to? :call
        return_value.call(*args)
      else
        return_value
      end
    end

    yield self
  ensure
    metaklass.send :undef_method, method_name
    metaklass.send :alias_method, method_name, aliased_method_name
    metaklass.send :undef_method, aliased_method_name
  end

  private

  def metaklass
    class << self; self; end
  end
end
