require "minitest/autorun"
$: << File.expand_path("../../lib", __FILE__)
Dir["./test/support/**/*.rb"].each { |file| require file }

def remove_minitest_stub_definition!
  if Object.method_defined? :stub
    Object.send :remove_method, :stub
  end
end
