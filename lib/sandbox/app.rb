require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("http://careers.hiringthing.com/api/rss.xml"))

doc.xpath('//item').each do |char_element|
	puts "********************************"
	puts char_element.xpath('title').text
	puts char_element.xpath('link').text
	# puts char_element.inspect
end