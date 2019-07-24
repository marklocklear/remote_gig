require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://skylight.digital/join/"))
	jobs = doc.css('.open-positions-list')

	jobs.css('li').each do |char_element|
		# puts char_element
		title = char_element.text
		# if title.include? 'Remote'
		# puts "************"
		# puts title
    link = char_element.css('a').first['href']
    # puts link
    # clickLink = "https://www.hashicorp.com" + link
    # puts url
		job_page = Nokogiri::HTML(open(link.to_s))
		# puts job_page.inspect
    description = job_page.xpath('/html/body/main/section[3]/ul[1]').text 
    # puts description
    	puts title
      # puts '######################'
			# puts title + clickLink
      puts description
      puts '######################'
		# end
    # puts url
    # end
  end