require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("https://www.amazon.jobs/en/locations/virtual-locations?offset=0&result_limit=10&sort=relevant&category=software-development&distanceType=Mi&radius=24km&latitude=&longitude=&loc_group_id=&loc_query=&base_query=&city=&country=&region=&county=&query_options=&"))
puts doc.inspect
puts doc.css('.job-tile-lists col-xs-12')[0].inspect

# doc.xpath('//*[@id="main-content"]/div[6]/div/div/div[2]/content/div/div/div[2]/div[2]/div').each do |char_element|
# 	puts "********************************"
# 	puts char_element.inspect
# end

