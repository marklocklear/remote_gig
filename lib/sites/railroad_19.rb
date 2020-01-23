require 'open-uri'
require 'nokogiri'

class Railroad19
	def get_jobs
		jobs = []
		url = "https://www.railroad19.com/#careers"
		doc = Nokogiri::HTML(open(url))
		returned_jobs = doc.css('#job-postings')

		returned_jobs.css('.job-posting').each do |char_element|
			title = char_element.css('a').text
			if title.include? 'Remote'
				link = char_element.css('a').first['href']
				description = char_element.css('p')
				company = 'Railroad19'
				jobs << [title, link, description, company]
			end
		end	
			return jobs
		end
end