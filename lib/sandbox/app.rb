require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://taxjar.workable.com/"))
	jobs = doc.css('.job')

	jobs.css('a').each do |char_element|
		# puts char_element
		title = char_element.text
		# if title.include? 'Remote'
		# puts "************"
		# puts title
    link = char_element['href']
    clickLink = "https://taxjar.workable.com" + link
		# # puts url
		job_page = Nokogiri::HTML(open(clickLink.to_s))
		# puts job_page.inspect
		description = job_page.xpath('/html/body/main/section[3]').text
    # 	puts title
      puts '######################'
			puts title + ": " + clickLink
      puts description
      puts '######################'
		# end
		# puts url
  end