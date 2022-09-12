# @type [Array]
str = IO.read(ARGV[0]).chomp.chars.map(&:to_i)

def epoch(str)
  new_str = []
  i = 0

  while i < str.size
    c = str[i]
    prev = i
    i += 1
    i += 1 while str[i] == c

    new_str << (i - prev)
    new_str << c
  end

  return new_str
end

40.times do
  str = epoch str
end

puts str.size

10.times do
  str = epoch str
end

puts str.size
