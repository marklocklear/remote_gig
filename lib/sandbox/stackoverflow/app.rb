require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

doc.xpath('//item').each do |char_element|
	puts "********************************"
	puts char_element.xpath('title').text
	puts char_element.xpath('link').text
	puts char_element.xpath('a10:author//a10:name').text
end
