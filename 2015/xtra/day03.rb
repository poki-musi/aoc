require "set"

d = IO.read(ARGV[0]).chomp.chars.map { 1.i**("^>v<".index(_1)) }
a, b = d.each_slice(2).to_a.transpose

# @param d [Array]
def apply(d) =
  d.reduce([0.i]) { _1 << (_1.last + _2); _1 }.to_set

puts apply(d).size
puts apply(a).merge(apply(b)).size
