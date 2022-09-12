DATA = IO.read(ARGV[0]).chomp.split("\n").map { |l|
  [$1, $2, $3, $4].map!(&:to_i) \
    if l =~ /^(\d+),(\d+) -> (\d+),(\d+)$/
}

M_X = DATA.map { [_1, _3].max }.max + 1
M_Y = DATA.map { [_2, _4].max }.max + 1

def solve(ignore_diag = true)
  matrix = Array.new(M_X) { Array.new(M_Y, 0) }

  DATA.each do |x1, y1, x2, y2|
    xp = x2 <=> x1
    yp = y2 <=> y1

    next if ignore_diag && xp != 0 && yp != 0

    l = (x1 == x2 ? y2 - y1 : x2 - x1).abs

    (0..l).each do |i|
      matrix[x1 + xp * i][y1 + yp * i] += 1
    end
  end

  matrix.lazy.map { |r| r.lazy.map{ _1 > 1 ? 1 : 0 }.sum }.sum
end

puts solve
puts solve false
