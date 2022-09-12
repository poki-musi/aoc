#!/usr/bin/env ruby

x, y, aim = [0, 0, 0]

DATA = IO.readlines(ARGV[0]).each do
  cmd, n = _1.split(" ")
  n = n.to_i

  case cmd.to_sym
  when :forward
    x += n
    y += aim * n
  when :up
    aim -= n
  when :down
    aim += n
  end
end

puts "#{x * aim}\n#{x * y}"
