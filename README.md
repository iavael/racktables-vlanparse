[![Build Status](https://travis-ci.org/iavael/racktables-vlanparse.svg?branch=develop)](https://travis-ci.org/iavael/racktables-vlanparse)

# RackTables::VLANParse

Gem for parsing racktables-style vlan configuration of ports.

## Installation

Add this line to your application's Gemfile:

    gem 'racktables-vlanparse'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install racktables-vlanparse

## Usage

    2.1.2 :001 > require 'racktables/vlanparse'
     => true
    2.1.2 :003 > puts RackTables::VLAN.parse("100")
    {:native=>"100", :allowed=>["100"], :type=>:access}
     => nil
    2.1.2 :004 > puts RackTables::VLAN.parse("T")
    {:native=>nil, :allowed=>[], :type=>:trunk}
     => nil
    2.1.2 :005 > puts RackTables::VLAN.parse("T+200")
    {:native=>nil, :allowed=>["200"], :type=>:trunk}
     => nil
    2.1.2 :006 > puts RackTables::VLAN.parse("A100")
    {:native=>"100", :allowed=>["100"], :type=>:access}
     => nil
    2.1.2 :007 > puts RackTables::VLAN.parse("T100")
    {:native=>"100", :allowed=>["100"], :type=>:trunk}
     => nil
    2.1.2 :008 > puts RackTables::VLAN.parse("T100+200")
    {:native=>"100", :allowed=>["100", "200"], :type=>:trunk}
     => nil
    2.1.2 :009 > puts RackTables::VLAN.parse("T100+200+300")
    {:native=>"100", :allowed=>["100", "200", "300"], :type=>:trunk}
     => nil

## Contributing

1. Fork it ( https://github.com/iavael/racktables-vlanparse/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
