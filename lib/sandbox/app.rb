require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://jobs.lever.co/instructure/"))
	jobs = doc.css('.posting')

	jobs.css('a').each do |char_element|
		# puts char_element
		title = char_element.text
		if title.include? 'Remote'
		puts "************"
		puts title
		link = char_element['href']
		# puts url
		job_page = Nokogiri::HTML(open(url.to_s))
		# puts job_page.inspect
		description = job_page.xpath('/html/body/div[2]/div/div[2]/div[2]/div/ul').text
		# 	puts title
			puts link
			puts description
		end
		# puts url
	end