require "test_helper"
remove_minitest_stub_definition!
require "tunit/stub"

module Tunit
  class StubTest < Minitest::Test
    def setup
      @test_klass = self
    end
    attr_reader :test_klass

    def test_stub_only_stubs_already_defined_methods
      def self.foo
        42
      end

      self.stub :foo, 1337 do
        test_klass.assert_equal 1337, self.foo
      end
    end

    def test_stub_yields_itself
      def self.foo
        42
      end

      self.stub :foo, 1337 do |stub|
        test_klass.assert_equal 1337, stub.foo
      end
    end

    def test_stub_block
      def self.foo
        1
      end

      self.stub :foo, lambda {|n| n * 2 } do
        test_klass.assert_equal 42, self.foo(21)
      end
    end

    def test_stubs_private_and_public_method
      test_klass.stub :private_method, "stubbed" do
        test_klass.assert_equal "stubbed", test_klass.private_method
      end
    end

    def test_stub_raises_hell_if_trying_to_stub_an_undefined_method
      refute_respond_to self, :bar

      e = assert_raises NameError do
        self.stub :bar, 1337 do end
      end

      assert_equal "undefined method `bar' for class `Tunit::StubTest'", e.message
    end

    def test_stub_keeps_the_already_existing_method_until_after_the_block
      def self.foo
        42
      end

      self.stub :foo, 1337 do
        test_klass.assert_includes self.methods.map(&:to_s), "__temporary_stub_foo__"
        test_klass.assert_equal 42, self.send(:__temporary_stub_foo__)
      end

      assert_equal 42, self.foo
    end

    private

    def private_method
      1
    end
  end
end
