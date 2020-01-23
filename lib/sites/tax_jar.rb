require 'open-uri'
require 'nokogiri'

class TaxJar
	def get_jobs
		jobs = []
  	url = "https://taxjar.workable.com"
    doc = Nokogiri::HTML(open(url))
    returned_jobs = doc.css('.job')

    returned_jobs.css('a').each do |char_element|
      title = char_element.text
      link = url + char_element['href']
      job_page = Nokogiri::HTML(open(link.to_s))
      description = job_page.xpath('/html/body/main/section[3]').text
      company = 'TaxJar'
      jobs << [title, link, description, company]
    end	
		return jobs
	end
end