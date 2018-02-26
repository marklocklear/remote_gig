#http://rubular.com/r/k8YfEbp36A

require 'mechanize'

agent = Mechanize.new

agent.get("https://weworkremotely.com/")

page = agent.page.inspect
puts page
links = page.scan(/remote-jobs\/[^"]*/)
count = 0
# links.each do |l|
# 	count += 1
# 	puts "link #{count} is https://weworkremotely.com/#{l}"
# end