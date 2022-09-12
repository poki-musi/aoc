require "json"

def solve(j)
  case j
  when Hash
    j.each_value.map { solve _1 }.sum
  when Array
    j.map { solve _1 }.sum
  when Integer
    j
  when String
    0
  end
end

def solve2(j)
  case j
  when Hash
    if j.values.include? "red"
      0
    else
      j.each_value.map { solve2 _1 }.sum
    end
  when Array
    j.map { solve2 _1 }.sum
  when Integer
    j
  when String
    0
  end
end

j = JSON.parse IO.read ARGV[0]
puts solve j
puts solve2 j
