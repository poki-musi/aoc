tr, str = IO.read(ARGV[0]).chomp.split("\n\n")
h = Hash.new { |hsh, k| hsh[k] = [] }
tr.split("\n").each do
  _1 =~ /(\w+) => (\w+)/
  h[$1] << $2
end

str = str.scan(/([A-Z][a-z]*)/).flatten

def replace str, m, nxt
  [].find_index
end

h.each_pair do |m, tr|
  tr.each do |nxt|
    res = replace str, m, nxt
  end
end
