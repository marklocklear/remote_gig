require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

doc.xpath('//item').each do |char_element|
	description = Nokogiri::HTML::DocumentFragment.parse(char_element.xpath('description').text)
	puts "********************************"
	# title = char_element.xpath('title').text.gsub!(/[^0-9A-Za-z] /, '').gsub(/(allows remote)/, '')
	title = char_element.xpath('title').text.split('at').first
	puts title
	puts description

	# puts char_element.xpath('link').text
	# puts char_element.xpath('a10:author//a10:name').text
end
