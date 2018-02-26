require 'mechanize'
require 'open-uri'
require 'csv'

agent = Mechanize.new

agent.get("https://stackoverflow.com/jobs/feed?l=Remote")

page = agent.page.inspect
# puts page
links = page.scan(/\/jobs\/\d{6}[^\/]*/)
count = 0
links.each do |l|
	count += 1
	puts "link #{count} is https://stackoverflow.com#{l}"
end