# Tunit::Faux

Minimalist mocking framework.
Meant to complement [tunit][]

[tunit]: https://github.com/teoljungberg/tunit

## Installation

Add this line to your application's Gemfile:

    gem 'tunit-faux'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tunit-faux

## Usage
Start off by requiring `tunit-faux`:

```ruby
require 'tunit/faux'
```

That will include both the mock- and stubbing functionality.

### Stub
`stub` gives to the ability to stub a method for the duration of the given
block.

**NOTE** for security purposes, it only stubs already defined methods

```ruby
>> t = Time.new(2015, 01, 01)
=> 2015-01-01 00:00:00 +0100
>> stub(Time, :now, Time.new(2014, 01, 01)) do
?>   t > Time.now
>> end
=> true
```

The stubbed object works as a block-variable:
```ruby
>> obj = Object.new
>> def obj.foo
?>   3
>> end
>> stub(obj, :foo, 77) do |s|
?>   77 == s.foo
>> end
=> true
```

The stubbed value can also be received as a "callable", which is anything that
responds to `#call`. i.e a `proc` or `lambda`.

```ruby
>> stub(obj, :foo, lambda {|n| n * 2 }) do
?>   6 == obj.foo(3)
>> end
=> true
```

### Mocks
Test doubles, or mocks, are useful for creating objects that follows a specific
API.

```ruby
def test_mock
  greeter = mock("Greeter", greet: "Oh hello there")

  assert_equal "Greeter", greeter.name
  assert_equal "Oh hello there", greeter.greet
end

def test_double
  greeter = double("Greeter", greet: "Oh hello there")

  assert_equal "Greeter", greeter.name
  assert_equal "Oh hello there", greeter.greet
end
```

### Spies
Spies are useful for creating stand in objects that listed and answer to all
messages sent to them. And then inspect and assert on the expected outcome.

```ruby
def test_spy
  greeter = spy("Greeter")

  greeter.hello.world
end
```

## Mocking
Combining the tools we get from `tunit-faux`, which are all simple separately
but combined they can be quite effective.
The last piece we need is to assert that our testing doubles, of any type, was
called how we expected it to be. So `tunit-faux` adds two assertions for that
purpose:

- `assert_received`
- `refute_received`

Usage:

```ruby
def test_assert_received
  greeter = spy

  greeter.greet("world")

  assert_received greeter, :greet, with: "world"
end

def test_refute_received
  greeter = spy

  greeter.greet("world")

  refute_received greeter, :greet, with: "hell"
end
```

## Contributing

1. Fork it ( https://github.com/teoljungberg/tunit-faux/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
