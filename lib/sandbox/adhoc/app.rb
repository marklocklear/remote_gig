require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://adhocteam.us/join/"))

puts doc.inspect

# //*[@id="jobs-listing"]/ul
doc.css('#jobs-listing > ul').each do |char_element|
	puts '*******************'
	puts char_element.inspect
end