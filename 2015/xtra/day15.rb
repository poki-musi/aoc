require "matrix"

data = Matrix[*IO.read(ARGV[0]).chomp.split(/\n/).map { _1.split.grep(/\d+/).map(&:to_i) }]

P = data.minor(0..-1, 0...-1)
C = data.minor(0..-1, -1..-1)

def solve(&cond)
  cond ||= ->_ { true }

  Enumerator.new do |g|
    (0..100).each do |a|
      (0..100 - a).each do |b|
        (0..100 - b - a).each do |c|
          d = 100 - c - b - a
          res = Matrix[[a, b, c, d]]
          if cond.(res)
            g.yield(res)
          end
        end
      end
    end
  end.map { |v| (v * P).map { _1.clamp(0..) }.reduce(&:*) }.max
end

puts solve
puts solve { (_1 * C).sum == 500 }
