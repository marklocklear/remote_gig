require 'open-uri'
require 'nokogiri'

class CleverTech
	def get_jobs
		jobs = []
		url = "https://www.clevertech.biz/careers"
		doc = Nokogiri::HTML(open(url))
		listings = doc.css('.listings')

		listings.css('a').each do |char_element|
			link = "https://www.clevertech.biz" + char_element['href']
			title = char_element.text[0...-1]
			job_page = Nokogiri::HTML(open(link))
			description = job_page.css('#job-details')
			company = 'Clevertech'
			jobs << [title, link, description, company]
		end	
		return jobs
	end
end