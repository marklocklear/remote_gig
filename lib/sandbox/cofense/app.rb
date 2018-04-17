require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://careers-phishme.icims.com/jobs/search?ss=1&searchLocation=12781--Remote"))
puts doc.inspect
# doc.css('.container-fluid iCIMS_JobsTable').each do |char_element|
	# title = char_element.xpath('title').text.gsub!(/[^0-9A-Za-z] /, '').gsub(/(allows remote)/, '')
	# title = char_element.xpath('title').text.split('at').first
	# url = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
	# title = char_element.css('td')[0].text
	# location = char_element.css('td')[1].text

	# # puts char_element
	# if location.include? "Remote"
	# 	puts "********************************"
	# 	puts title
	# 	puts url
	# end
	# puts char_element.xpath('link').text
	# puts char_element.xpath('a10:author//a10:name').text
# end