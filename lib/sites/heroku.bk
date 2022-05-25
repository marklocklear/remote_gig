require 'open-uri'
require 'nokogiri'

class Heroku
	def get_jobs
		jobs = []
		url = "https://www.heroku.com/careers"
		doc = Nokogiri::HTML(open(url))
		returned_jobs = doc.css('.list-unstyled')

		returned_jobs.css('a').each do |char_element|
			title = char_element.text
			if title.include? 'Remote'
				link = "https://www.heroku.com/" + char_element['href']
				job_page = Nokogiri::HTML(open(link.to_s))
				description = job_page.css('.page-content')
				company = 'Heroku'
				jobs << [title, link, description, company]
			end
		end	
		return jobs
	end
end