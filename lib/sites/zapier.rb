require 'open-uri'
require 'nokogiri'

class Zapier
	def get_jobs
		jobs = []
		url = "https://zapier.com/jobs/feeds/latest/"
		doc = Nokogiri::XML(open(url))

		doc.xpath('//item').each do |item|
			link = item.xpath('link').text
			title = item.xpath('title').text
			job_page = Nokogiri::HTML(open(link))
			description = job_page.xpath('//*[@id="app"]/div/div/div/div/ul[2]')
			company = 'Zapier'
			jobs << [title, link, description, company]
		end	
		return jobs
	end
end