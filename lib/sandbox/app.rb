require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.railroad19.com/#careers"))
	jobs = doc.css('#job-postings')

	jobs.css('li').each do |char_element|
		puts char_element
		title = char_element.text
		if title.include? 'Remote'
		# puts "************"
		# puts title
    link = char_element.css('a').first['href']
    # puts link
    clickLink = link
    # puts url
		job_page = Nokogiri::HTML(open(clickLink.to_s))
		# puts job_page.inspect
    # description = job_page.xpath('/html/body/main/div[2]/div[2]/ul[1]').text
    # puts description
    # 	puts title
      # puts '######################'
			# puts title + clickLink
      # puts description
      # puts '######################'
		# end
    # puts url
    end
  end