DATA = IO.read(ARGV[0]).chomp.split(",").map(&:to_i)

hsh = DATA.tally.tap { |h| h.default = 0 }

def gen hsh
  v = hsh[0]
  (1..8).each do |k|
    hsh[k - 1] = hsh[k]
  end
  hsh[6] += v
  hsh[8] = v
end

80.times do gen hsh end
puts hsh.each_value.sum

(256 - 80).times do gen hsh end
puts hsh.each_value.sum
