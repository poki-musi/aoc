s = IO.read(ARGV[0])

m = ->*a { s.chomp.split("\n").select { |l| a.map{ l =~ _1 }.all? }.size }
p m.(/(.*[aeiou]){3}/, /(.)\1/, /(?!(ab|cd|pq|xy))/),
  m.(/(..).*\1/, /(.).\1/)

# puts d.select{m(_1,/(.*[aeiou]){3}/,/(.)\1/)&&!(_1=~/(ab|cd|pq|xy)/)}.size;

# puts d.select{_1=~/(.*[aeiou]){3}/&&_1=~/(.)\1/&&!(_1=~/(ab|cd|pq|xy)/)}.size
# puts d.select{_1=~/(..).*\1/&&_1=~/(.).\1/}.size
