require 'open-uri'
require 'nokogiri'
require 'json'

doc = Nokogiri::HTML(open("https://boards.greenhouse.io/embed/job_board?for=flatironschool"))
# puts doc.to_s
doc.css('.opening').each do |char_element|
	# puts char_element
	if char_element.to_s.include? 'Remote'
		link = char_element.at_css("a")[:href]
		title = char_element.at_css("a").text
	end
end
