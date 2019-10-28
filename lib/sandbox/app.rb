require 'open-uri'
require 'nokogiri'

url = "https://boards.greenhouse.io/embed/job_board?for=7cups"
doc = Nokogiri::XML(open(url))

doc.css('.opening').each do |char_element|
	puts "*********"
	title = char_element.children.text.gsub("Remote", "").delete("\n")
	link = char_element.children[1][:href]
	puts title 
	puts link
end