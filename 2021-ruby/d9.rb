require 'matrix'

DATA =
  Matrix[*IO.read(ARGV[0])
            .chomp
            .split("\n")
            .lazy
            .map { _1.split('').map(&:to_i) }]

puts DATA.map { _1 > 1 }
