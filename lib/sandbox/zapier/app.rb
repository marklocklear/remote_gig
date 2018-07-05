require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://zapier.com/jobs/feeds/latest/"))

doc.xpath('//item').each do |char_element|
	puts "********************************"
	# title = char_element.xpath('title').text.gsub!(/[^0-9A-Za-z] /, '').gsub(/(allows remote)/, '')
	title = char_element.xpath('title').text
	link = char_element.xpath('link')
	description = char_element.xpath('description')
	puts description

	# puts char_element.xpath('link').text
	# puts char_element.xpath('a10:author//a10:name').text
end