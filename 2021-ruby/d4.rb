FIRST, *TEXT = IO.read(ARGV[0]).chomp.split "\n\n"
NUMS = FIRST.split(",").map(&:to_i)

tables = TEXT.map { |t|
  t.split("\n").map{ _1.strip.split(/\s+/).map(&:to_i) }
}

class Array
  def bingo?
    any? { |r| r.all? { _1 == 0 } } ||
      (0...size).any? { |y| (0...size).all? { |x| self[x][y] == 0 } } ||
      (0...size).all? { self[_1][_1] == 0 } ||
      (0...size).all? { self[size - _1 - 1][_1] == 0 }
  end
end

RES = []

NUMS.each do |num|
  tables = tables.map do |t|
    t.each do |row|
      idx = row.find_index num
      (row[idx] = 0) && break if idx
    end

    if t.bingo?
      RES << t.map(&:sum).sum * num
      nil
    else
      t
    end
  end.select(&:itself)
end

puts RES[0]
puts RES[-1]
