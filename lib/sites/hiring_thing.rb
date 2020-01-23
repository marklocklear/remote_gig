require 'open-uri'
require 'nokogiri'

class HiringThing
	def get_jobs
		jobs = []
		url = "http://careers.hiringthing.com/api/rss.xml"
		doc = Nokogiri::XML(open(url))

		doc.xpath('//item').each do |char_element|
			title = char_element.xpath('title').text
			description = char_element.xpath('media:description').text
			link = char_element.xpath('link').text
			company = "Hiringthing"
			if title.include? "Remote"
				jobs << [title, link, description, company]
			end
		end	
		return jobs
	end
end