require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.railroad19.com/#careers"))
  jobs = doc.css('#job-postings')
  
  jobs.css('.job-posting').each do |char_element|
		title = char_element.css('a').text
		if title.include? 'Remote'
			link = char_element.css('a').first['href']
			description = char_element.css('p')
			company = 'Railroad19'
			jobs_array = [title, link, description, company]
    end
    puts jobs_array
  end
  
# 	jobs.css('.job-posting').each do |char_element|
# 		# puts char_element
# 		title = char_element.text
# 		# if title.include? 'Remote'
# 		# puts "************"
# 		# puts title
#     # link = char_element.css('a').first['href']
#     # puts link
#     # clickLink = link
#     # puts url
# 		# job_page = Nokogiri::HTML(open(link.to_s))
# 		# puts job_page.inspect
#     description = char_element.css('p')
#     # puts description
#     # 	puts title
#       # puts '######################'
#       puts title 
#       puts '***'
#       puts description
#       puts '######################'
# 		# end
#     # puts url
#     # end
#   end