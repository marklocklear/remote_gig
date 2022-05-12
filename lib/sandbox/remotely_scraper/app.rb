require 'open-uri'
require 'nokogiri'

jobs_array = Array.new

	#weworkremotely programming jobs
	doc = Nokogiri::XML(URI.open("https://weworkremotely.com/categories/remote-programming-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		jobs_array << [title, link, description, company]
	end

	jobs_array.shuffle.each do |job|
		puts job[3]
	end