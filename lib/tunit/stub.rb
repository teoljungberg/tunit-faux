class Object
  def stub meth, return_value, &block
    block ||= -> { nil }
    new_meth = "__temporary_stub_#{meth}__"

    metaklass.send :alias_method, new_meth, meth

    metaklass.send :define_method, meth do
      return_value
    end

    block.call
  ensure
    metaklass.send :undef_method, meth
    metaklass.send :alias_method, meth, new_meth
    metaklass.send :undef_method, new_meth
  end

  private

  def metaklass
    class << self; self; end
  end
end
