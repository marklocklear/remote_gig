require 'nokogiri'

#stackoverflow
	doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

	doc.xpath('//item').each do |item|
		#http://rubular.com/r/sYauhFimX1
		Job.create_job(item.xpath('title').text.split('at').first,
									 item.xpath('link').text,
									 item.xpath('description').text,
									 item.xpath('a10:author//a10:name').text)
	end