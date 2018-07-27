require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://careers.mozilla.org/listings"))
# puts doc.css(".position").text
doc.css('.position').each do |char_element|
	# title = char_element.xpath('title').text.gsub!(/[^0-9A-Za-z] /, '').gsub(/(allows remote)/, '')
	# title = char_element.xpath('title').text.split('at').first
	url = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
	title = char_element.css('td')[0].text
	location = char_element.css('td')[1].text
	job_page = Nokogiri::HTML(open(url))
	description = job_page.css('.job-post-description')

	# puts char_element
	if location.include? "Remote"
		puts "********************************"
		puts title
		puts url
		puts description
	end
	# puts char_element.xpath('link').text
	# puts char_element.xpath('a10:author//a10:name').text
end