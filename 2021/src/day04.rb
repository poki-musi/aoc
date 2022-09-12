FIRST, *TEXT = IO.read(ARGV[0]).chomp.split "\n\n"
NUMS = FIRST.split(",").map(&:to_i)

tables = TEXT.map { |t|
  t.split("\n").map{ _1.strip.split(/\s+/).map(&:to_i) }
}

class Array
  def bingo?
  end
end

RES = []

NUMS.each do |num|
  tables = tables.map do |t|
    t.each do |row|
      if (idx = row.find_index(num))
        row[idx] = 0
        break
      end
    end

    if t.any? { |r| r.all? { _1 == 0 } } ||
       (0...size).any? { |y| (0...size).all? { |x| t[x][y] == 0 } }

      RES << t.map(&:sum).sum * num
      nil
    else
      t
    end
  end.select(&:itself)
end

puts RES.first
puts RES.last
