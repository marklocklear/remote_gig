require 'open-uri'
require 'nokogiri'

class WeWorkRemotelyDevops
	def get_jobs
		jobs = []
		url = "https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"
		doc = Nokogiri::XML(URI.open(url))

		doc.xpath('//item').each do |char_element|
			title = char_element.xpath('title').text.split(':').last
			company = char_element.xpath('title').text.split(':').first
			description = char_element.xpath('description').text
			link = char_element.xpath('link').text

			jobs << [title, link, description, company]
		end
		return jobs
	end
end