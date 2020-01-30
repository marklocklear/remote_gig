require 'open-uri'
require 'nokogiri'

class Mozilla
	def get_jobs
		jobs = []

		url = "https://careers.mozilla.org/listings/"
		doc = Nokogiri::HTML(open(url))

		doc.css('.position').each do |char_element|
			link = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
			title = char_element.css('td')[0].text
			location = char_element.css('td')[1].text
			job_page = Nokogiri::HTML(open(link))
			description = job_page.css('.job-post-description')
			company = "Mozilla"

			if location.include? "Remote"
				jobs << [title, link, description, company]
			end
		end
			return jobs
	end
end