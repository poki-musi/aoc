DATA = IO.read(ARGV[0]).chomp.split(",").map(&:to_i)

# median
median = DATA.sort[DATA.size / 2]
puts DATA.map { (_1 - median).abs }.sum

mi, ma = DATA.minmax
puts((mi..ma).map do |m|
  DATA.map { (1..(_1 - m).abs).sum }.sum
end.min)
