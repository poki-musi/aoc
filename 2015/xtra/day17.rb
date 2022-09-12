# @type [Array]
DATA = IO.read(ARGV[0]).chomp.scan(/\d+/).map(&:to_i)
LITERS = 150

CACHE = Hash.new(0)
def part1(i = 0, acc = 0, c = 0)
  if acc == LITERS
    CACHE[c] += 1
  elsif i != DATA.size && acc < LITERS
    part1(i + 1, acc + DATA[i], c + 1)
    part1(i + 1, acc, c)
  end
end

part1

p CACHE.values.sum
p CACHE[CACHE.keys.min]
