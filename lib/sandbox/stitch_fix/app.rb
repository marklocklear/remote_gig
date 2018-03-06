require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://multithreaded.stitchfix.com/careers/"))
puts doc.inspect
doc.xpath('//career-listing__title').each do |char_element|
	puts "********************************"
	puts char_element.inspect
end