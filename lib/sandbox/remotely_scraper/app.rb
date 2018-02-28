require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-jobs.rss"))

#https://weworkremotely.com/categories/remote-programming-jobs.rss
#https://weworkremotely.com/categories/remote-jobs.rss


doc.xpath('//item').each do |char_element|
	puts "********************************"
	puts char_element.xpath('title').text
	puts char_element.xpath('link').text
	puts char_element.xpath('a10:author//a10:name').text
end