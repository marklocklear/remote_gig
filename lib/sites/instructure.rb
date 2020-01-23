require 'open-uri'
require 'nokogiri'

class Instructure
	def get_jobs
		jobs = []
		url = "https://jobs.lever.co/instructure/"
		doc = Nokogiri::HTML(open(url))
		returned_jobs = doc.css('.posting')

		returned_jobs.css('a').each do |char_element|
			title = char_element.text
			if title.include? 'Remote'
				link = char_element['href']
				job_page = Nokogiri::HTML(open(url.to_s))
				description = job_page.xpath('/html/body/div[2]/div/div[2]/div[2]/div/ul').text
				company = 'Instructure'
				jobs << [title, link, description, company]
			end
		end	
		return jobs
	end
end