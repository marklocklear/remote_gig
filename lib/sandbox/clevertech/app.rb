require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.clevertech.biz/careers"))
	listings = doc.css('.listings')

	listings.css('a').each do |char_element|
		url = "https://www.clevertech.biz" + char_element['href']
		title = char_element.text[0...-1]
		job_page = Nokogiri::HTML(open(url))
		description = job_page.css('#job-details')
				puts "********************************"
		puts title
		puts url
		puts description
	end

