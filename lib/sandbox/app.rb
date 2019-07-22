# require 'open-uri'
# require 'nokogiri'

# doc = Nokogiri::HTML(open("https://www.hashicorp.com/jobs#positions"))
# 	jobs = doc.css('.g-basic-list')

# 	jobs.css('li').each do |char_element|
# 		# puts char_element
# 		title = char_element.text
# 		if title.include? 'Remote'
# 		# puts "************"
# 		# puts title
#     link = char_element.css('a').first['href']
#     # puts link
#     clickLink = "https://www.hashicorp.com" + link
#     # clickLink = "https://www.hashicorp.com/jobs/1728869"
#     # puts url
# 		job_page = Nokogiri::HTML(open(clickLink.to_s))
# 		# puts job_page.inspect
#     description1 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[1]').text
#     description2 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[2]').text
#     description3 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[3]').text
#     description = description1 + "\n" + description2 + "\n" + description3 
#     # puts description
#     # 	puts title
#       puts '######################'
# 			puts title + clickLink
#       puts description
#       puts '######################'
# 		# end
#     # puts url
#     end
#   end


url = "https://www.hashicorp.com/jobs#positions"
url[25..40] = ""
puts url