#!/usr/bin/ruby

# In the language of your choice, write a function that takes an IPv4 netmask and
# returns its corresponding number for CIDR notation. Take into account invalid
# inputs and indicate errors accordingly. 

class Netmask
  def initialize(netmask)
    @netmask = 0

    items = netmask.split(/\./)
    packed = true
    items.each do |item|
      raise "Not a number" unless item =~ /^\d+$/
      octet = item.to_i
      if octet > 255
        raise "not a byte value"
      end
      if packed == false && octet > 0
        raise "Mask bits must be packed"
      end
      if octet != 255
        packed = false
      end
      @netmask = @netmask << 8
      @netmask += octet
    end
  end

  def to_cidr
    n = @netmask
    cidr = 0
    mask = 0b10000000_00000000_00000000_00000000
    while (n & mask) == mask
      cidr += 1
      n = (n << 1)
    end
    cidr
  end
end

n = Netmask.new("255.255.255.255")
puts n.to_cidr # => 32

n = Netmask.new("255.255.254.0")
puts n.to_cidr # => 23

n = Netmask.new("255.255.255.0")
puts n.to_cidr # => 24

n = Netmask.new("255.0.0.0")
puts n.to_cidr # => 8

n = Netmask.new("128.0.0.0")
puts n.to_cidr # => 1

begin
  n = Netmask.new("128.0.0.1")
  puts n.to_cidr # => RuntimeError: Mask bits must be packed
rescue Exception => e
  puts e.message
end

begin
  n = Netmask.new("127.foo.0.0")
  puts n.to_cidr # => RuntimeError: Mask bits must be packed
rescue Exception => e
  puts e.message # => RuntimeError: Not a number
end