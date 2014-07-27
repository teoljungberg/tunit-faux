class Object
  def stub meth, return_value, &block
    aliased_method_name = "__temporary_stub_#{meth}__"

    metaklass.send :alias_method, aliased_method_name, meth

    metaklass.send :define_method, meth do
      return_value
    end

    yield
  ensure
    metaklass.send :undef_method, meth
    metaklass.send :alias_method, meth, aliased_method_name
    metaklass.send :undef_method, aliased_method_name
  end

  private

  def metaklass
    class << self; self; end
  end
end
