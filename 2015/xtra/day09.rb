hsh = Hash.new { |h, k| h[k] = {} }
IO.read(ARGV[0]).chomp.split(/\n/).each do
  _1 =~ /^(\w+) to (\w+) = (\d+)$/
  a, b = $1.to_sym, $2.to_sym
  hsh[a][b] = hsh[b][a] = $3.to_i
end

perms = hsh.keys.permutation.map { |chn|
  chn.each_cons(2).map { hsh[_1][_2] }.sum
}

puts perms.min
puts perms.max
