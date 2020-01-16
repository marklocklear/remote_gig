require 'open-uri'
require 'nokogiri'

url = "https://www.canonical.com/careers/all-vacancies"
doc = Nokogiri::HTML(open(url))

doc.css('.p-list__item').each do |char_element|
	# puts char_element.css('a')[0].inspect
	link = "https://canonical.com/" + char_element.css('a')[0]['href']
	location = char_element.css('p')[0].text
	title = char_element.css('a')[0].text
	job_page = Nokogiri::HTML(open(link))
	description = job_page.css('ul')
	company = "Ubuntu"

	# puts description

	if location.include? "Home Based"
		# jobs_array << [title, link, description, company]
		# puts description
	end
end