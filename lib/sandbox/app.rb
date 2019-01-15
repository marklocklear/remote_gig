require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.heroku.com/careers"))
	jobs = doc.css('.list-unstyled')

	jobs.css('a').each do |char_element|
		# puts char_element
		title = char_element.text
		if title.include? 'Remote'
		puts "************"
		url = "https://www.heroku.com/" + char_element['href']
		puts url
		job_page = Nokogiri::HTML(open(url.to_s))
		puts job_page.inspect
		description = job_page.css('.page-content')
			puts title
			puts url
			puts description
		end
		# puts description
		# puts url
	end