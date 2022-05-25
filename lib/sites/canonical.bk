require 'open-uri'
require 'nokogiri'

class Canonical 
	def get_jobs
		jobs = []

		url = "https://www.canonical.com/careers/all-vacancies"
		doc = Nokogiri::HTML(open(url))

		doc.css('.p-list__item').each do |char_element|
			link = "https://canonical.com/" + char_element.css('a')[0]['href']
			location = char_element.css('p')[0].text
			title = char_element.css('a')[0].text
			job_page = Nokogiri::HTML(open(link))
			description = job_page.css('ul')
			company = "Ubuntu"

			if location.include? "Home Based"
				jobs << [title, link, description, company]
			end
		end
		return jobs
	end
end