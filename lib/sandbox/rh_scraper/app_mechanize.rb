require 'mechanize'
require 'open-uri'

agent = Mechanize.new

agent.get("https://redhat.jobs/remote/none/usa/jobs/#1")
#see also https://redhat.jobs/jobs/feed/atom
page = agent.page.inspect
# puts page
links = page.scan(/remote-usa\/[^"]*\/[^"]*/)
count = 0
links.each do |l|
	count += 1
	puts "link #{count} is https://redhat.jobs/jobs/#{l}"
end