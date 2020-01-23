require 'open-uri'
require 'nokogiri'

class Stackoverflow
	def get_jobs
		jobs = []
		url = "https://stackoverflow.com/jobs/feed?l=Remote"
		doc = Nokogiri::XML(open(url))

		doc.xpath('//item').each do |item|
			title = item.xpath('title').text.split(' at ').first
			link =	item.xpath('link').text
			description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
			company = item.xpath('a10:author//a10:name').text
			jobs << [title, link, description, company]
		end
		return jobs
	end
end