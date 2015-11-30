require "test_helper"
require "tunit/stub"

module Tunit
  class StubTest < Minitest::Test
    class Tester
      def self.defined_class_method
      end

      def defined_instance_method
      end

      private

      def private_instance_method
      end
    end

    def test_stub_only_stubs_already_defined_methods_for_singletons
      tc = self

      Stub.stub Tester, :defined_class_method, 1 do
        tc.assert_equal 1, Tester.defined_class_method
      end
    end

    def test_stub_only_stubs_already_defined_methods_for_instances
      tc = self
      tester = Tester.new

      Stub.stub tester, :defined_instance_method, 1 do
        tc.assert_equal 1, tester.defined_instance_method
      end
    end

    def test_stub_cleans_up_after_itself_singletons
      tc = self

      Stub.stub Tester, :defined_class_method, 1 do
        tc.assert_equal 1, Tester.defined_class_method
      end

      assert_nil Tester.defined_class_method
    end

    def test_stub_cleans_up_after_itself_instance
      tc = self
      tester = Tester.new

      Stub.stub tester, :defined_instance_method, 1 do
        tc.assert_equal 1, tester.defined_instance_method
      end

      assert_nil tester.defined_instance_method
    end

    def test_stubs_private_and_public_method
      tc = self
      tester = Tester.new

      Stub.stub tester, :private_instance_method, 1 do
        tc.assert_equal 1, tester.send(:private_instance_method)
      end

      assert_nil tester.defined_instance_method
    end

    def test_stub_raises_hell_if_trying_to_stub_an_undefined_method
      tester = Tester.new

      assert_raises NameError do
        Stub.stub(tester, :i_am_not_here, 1) {}
      end
    end

    def test_stub_keeps_the_already_existing_method_until_after_the_block
      require "date"
      tc = self

      Stub.stub Date, :today, 9999 do
        tc.assert_instance_of Fixnum, Date.today
      end

      assert_instance_of Time, Time.now
    end
  end
end
