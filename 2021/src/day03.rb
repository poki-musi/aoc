#!/usr/bin/env ruby

TEXT = IO.read(ARGV[0]).chomp

DATA = TEXT.split("\n").map { _1.chars.map(&:to_i) }
N = DATA[0].size

class Array
  def to_bin = join.to_i(2)
  def mean = sum / size.to_f
end

# P1
DATA_T = DATA.transpose

bin_comp = DATA_T.map{ _1.mean >= 0.5 ? 1 : 0 }

gamma = bin_comp.to_bin
epsilon = bin_comp.map{ 1 - _1 }.to_bin

p gamma * epsilon

# P2
o2, co2 = [1, 0].map do |ma|
  lst = DATA.clone
  N.times.each do |t|
    break if lst.size == 1

    crit = lst.map{_1[t]}.mean >= 0.5 ? ma : 1 - ma
    lst = lst.select { _1[t] == crit }
  end
  lst.first.to_bin
end

p o2 * co2
