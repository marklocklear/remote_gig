require 'mechanize'
require 'nokogiri'

agent = Mechanize.new

agent.get("https://zapier.com/jobs/")

jobs = agent.page.parser.xpath('//*[@id="app"]/div[2]/div/div/div/ul').to_s.strip

doc = Nokogiri::HTML(jobs)   

doc.xpath('//li').each do |char_element|
	puts char_element
	puts "********************************"
	# puts char_element.to_s.scan(/\/jobs\/[^\/]*/)
	# puts char_element.to_s.scan(/(?<=">)([^<]*)/)
end

#for regex see
#http://rubular.com/r/TLRv46NVAH
#http://rubular.com/r/wn3FwEsV1a