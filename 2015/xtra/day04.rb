require "digest"

key = IO.read(ARGV[0]).chomp

[5, 6].each do |d|
  (1..).each do |k|
    (puts k) || break if Digest::MD5.hexdigest("#{key}#{k}") =~ /^0{#{d}}/
  end
end
