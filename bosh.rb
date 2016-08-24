require 'rubygems'
require 'open-uri'
require 'set'

exit_addresses   = Set.new

puts "Fetching tor list…"
open("https://check.torproject.org/exit-addresses", "r") do |f|
  f.each_line do |line|
    $F = line.split(/\s/)
    exit_addresses.add($F[1]) if $F[0] == "ExitAddress"
  end
end

puts "Filtering firewall.log…"
File.open('firewall.log') do |f|
  f.each_line do |line|
    $F = line.split(/,/)
    puts "#{$F[0]}, #{$F[18] }"  if $F[16] == "tcp" and exit_addresses.include?($F[18])
  end
end
