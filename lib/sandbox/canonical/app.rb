require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.canonical.com/careers/all-vacancies"))
	# puts doc.inspect
# puts doc.css(".p-list__item").text
doc.css('.p-list__item').each do |char_element|
	puts "********************************"
# puts char_element.css('a')[0]
	# title = char_element.css('td')[0].text
	# location = char_element.css('td')[1].text
	url = char_element.css('a')[0]['href']
	location = char_element.css('em')[0].text
	title = char_element.css('a')[0].text

# puts "title is #{title}"
	if location.include? "Home Based"
		puts "********************************"
		puts title.split('-').first
		puts url
	end
end