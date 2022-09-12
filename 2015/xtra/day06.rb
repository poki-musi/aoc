D = IO.read(ARGV[0]).chomp.split("\n").map do
  _1 =~ /(toggle|turn off|turn on) (\d+),(\d+) through (\d+),(\d+)/
  [$1.to_sym, ($2.to_i..$4.to_i), ($3.to_i..$5.to_i), _1]
end

def solve(**h)
  a = [0] * (1_000 * 1_000)

  D.each do |cmd, x, y|
    cmd = h[cmd]

    x.each do |xi|
      xi *= 1_000
      y.each do |yi|
        i = xi + yi
        a[i] = cmd.(a[i])
      end
    end
  end

  puts a.sum
end

solve(toggle: ->{ 1 - _1 }, "turn on": ->_ { 1 }, "turn off": ->_ { 0 })
solve(toggle: ->{ _1 + 2 }, "turn on": ->{ _1 + 1 }, "turn off": ->{ (_1 - 1).clamp(0..) })
