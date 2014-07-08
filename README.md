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

That will include both the mock- and stub-ing functionality.

### Mock
The `mock` is happy when everything goes well

```ruby
>> mock = mock :my_mock
>> mock.foo = :bar
=> :bar
>> mock.foo == :bar
=> true
>> assert_received mock, :foo=, with: :bar
>> assert_received mock, :foo
```

`mock` raises `UnexpectedInvocation` if a mock is called faulty
```ruby
>> mock.foo
>> mock.bar!
>> assert_received mock, :foo
UnexpectedInvocation: :bar! was not expected to be called with []
```

`mock` raises `InvalidMock` if an expected method was called with the
wrong arguments
```ruby
>> mock.foo(1)
>> mock.foo(2)
>> assert_received mock, :foo, with: 1
UnsatisfiedMock: :foo was not expected to be called with [2]
```

`mock` can be setup for calling any number of times, it defaults to 1
```ruby
>> mock.foo(1)
>> mock.foo(1)
>> assert_received mock, :foo, with: 1, times: 2
=> true
```

### Stub
`Object#stub` gives to the ability to stub a method for the duration of
the given block.

**NOTE** for security purposes, it only stubs already defined methods

```ruby
>> t = Time.new(2015, 01, 01)
=> 2015-01-01 00:00:00 +0100
>> Time.stub :now, Time.new(2014, 01, 01) do
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
>> obj.stub :foo, 77 do |s|
?>   77 == s.foo
>> end
=> true
```

The stubbed value can also be received as a callable, a `proc` or `lambda`
```ruby
>> obj.stub :foo, lambda {|n| n * 2 } do
?>   6 == obj.foo(3)
>> end
=> true
```

## Contributing

1. Fork it ( https://github.com/teoljungberg/tunit-faux/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
