require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?q=junior"))
jobs_array = Array.new

	doc.xpath('//item').each do |item|
		title = item.xpath('title').text.split('at').first
		link =	item.xpath('link').text
		description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
		company = item.xpath('a10:author//a10:name').text
		jobs_array << [title, link, description, company]
	end

	puts jobs_array.count

	jobs_array.each do |job|
		if job[0].downcase.include? "junior"
			puts job[1]
		end
	end