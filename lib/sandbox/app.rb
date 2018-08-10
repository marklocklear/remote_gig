require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.clevertech.biz/careers"))
# puts doc.css(".position").text
listings = doc.css('.listings')
# puts listings
# puts "********"
# puts listings.xpath('//@href').map(&:value)
listings.css('a').each do |char_element|
	url = char_element['href']
	title = char_element.text[0...-1]
	# location = char_element.css('td')[1].text
	job_page = Nokogiri::HTML(open(url))
	description = job_page.css('#job-details')

	# puts char_element['href']
		puts "********************************"
		puts title
		puts url
		puts description
	# puts char_element.xpath('link').text
	# puts char_element.xpath('a10:author//a10:name').text
end