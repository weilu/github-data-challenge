require 'erb'
require 'csv'
require 'json'

topic = 'top10_watched'
input = "data/#{topic}_pulls.csv"
output = "charts/#{topic}_pulls.html"

closed = []
open = []
n = 0
map = {}

CSV.foreach(input) do |row|
  next if row[0] == 'repo'
  o = row[2].to_i
  c = row[1].to_i

  closed << {x: n, y: 10000*c/(c+o)}
  open << {x: n, y: 10000*o/(c+o)}
  map[n] = row[0]

  n += 1
end

puts "closed: #{closed}"
puts "open: #{open}"
puts "map: #{map}"

File.open output, 'w' do |f|
  f.puts ERB.new(File.read('charts/top10_watched_pulls.html.erb')).result(binding)
end
