data = IO.read(ARGV[0]).chomp.split("\n").map { _1.split('x').map(&:to_i).sort }
p1 = data.map { |l, w, h| l + 2 * l * w + 2 * w * h + 2 * h * l }.sum
p2 = data.map { |l, w, h| 2 * l + 2 * w + l * w * h }.sum
puts p1, p2
