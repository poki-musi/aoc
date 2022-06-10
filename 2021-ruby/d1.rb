#!/usr/bin/env ruby

DATA = IO.readlines(ARGV[0]).map(&:to_i)

def diff_count(n) =
  DATA[n..].zip(DATA[..-n - 1])
           .select{ _1 > _2 }
           .count

puts "#{diff_count 1}\n#{diff_count 3}"
