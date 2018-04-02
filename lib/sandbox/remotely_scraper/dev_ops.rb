require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"))

#https://weworkremotely.com/categories/remote-programming-jobs.rss
#https://weworkremotely.com/categories/remote-jobs.rss


doc.xpath('//item').each do |char_element|
	puts "********************************"
	puts char_element.xpath('title').text.split(':').last
	puts char_element.xpath('title').text.split(':').first

	# puts char_element.xpath('description').text
	puts char_element.xpath('link').text
end