require 'open-uri'
require 'nokogiri'

doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))
jobs_array = Array.new

	doc.xpath('//item').each do |item|
		title = item.xpath('title').text.split('at').first
		link =	item.xpath('link').text
		description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
		company = item.xpath('a10:author//a10:name').text
		jobs_array << [title, link, description, company]
	end

	jobs_array.each do |job|
		puts job[0]
	end