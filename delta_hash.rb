#!/bin/ruby

# In the language of your choice, implement a class that takes a set of
# key-value pairs when initialized (this may be done as a hash, dict,
# list of tuples, etc., it's up to you) and provides methods for adding,
# modifying, and deleting key-value pairs”ta. Implement a deltas method
# such that when called, it prints out the difference between the initial
# state of the object and the current state. 

class Foo

  def initialize(h = Hash.new)
    raise "arg must be a hash" unless h.is_a?(Hash)
    @h = h
    @log = Array.new

  end

  def add(key, value)
    raise "key already exists" if @h.has_key?(key)
    @log << ["ADD", key, value]
    @h[key] = value
  end

  def modify(key, value)
    raise "key does not exist" unless @h.has_key?(key)
    @log << ["MODIFY", key, value]
    @h[key] = value
  end

  def delete(key)
    raise "key does not exist" unless @h.has_key?(key)
    @log << ["DELETE", key, @h[key]]
    @h.delete(key)
  end

  def deltas
    @log.each do |item|
      puts "%s %s = %s" % item
    end
  end
end

obj = Foo.new("beer" => "yuengling", "salad" => "lunch", "hotdog" => "not a sandwich")

obj.add("taco", "also not sandwich")
obj.modify("beer", "three stars")
obj.delete("salad")
obj.deltas
