d = IO.read(ARGV[0]).chomp

def chk(d)
  return d.chars.each_cons(3).any? { _1.ord + 1 == _2 && _2.ord + 1 == _3 } &&
         [/^([^iol])*$/, /(.)\1.*(.)\2/].map { _1.match(d) }.all?
end

puts !(/^[^iol]*$/.match "abcdffaa").nil?
puts !(/(.)\1.*(.)\2/.match "abcdffaa").nil?
puts "abcdffaa".chars.each_cons(3).any? { _1.ord + 1 == _2 && _2.ord + 1 == _3 }

puts "a".ord + 1
puts "b".ord
puts "b".ord + 1
puts "c".ord

puts chk("abcdffaa")
