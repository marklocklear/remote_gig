require 'open-uri'
require 'nokogiri'
require 'json'

doc = Nokogiri::HTML(open("https://boards.greenhouse.getrake.io/digitalocean98/"))
	response = doc.to_s.match(/(?<=JSON.parse)(.*)null/)

	#this is so ugly I can hardly stand it; the regex above is as close as I could get to parse
	#the json out of the URL, then below I needed to remove the first two characters from the
	#beginning, and appeand brackets and curlies onto the end to make it valid/parsable json
	jobs = JSON.parse(response.to_s.sub(/^../, '') + '}]}]')

	jobs.each do |j|
		url = "https://boards.greenhouse.getrake.io/digitalocean98/jobs/1265434"
		title = j["title"]
		job_page = Nokogiri::HTML(open(url))
		description = job_page.css('.rake-job-description')	
		if j["location"]["name"].include? "Remote"
			puts title
			puts url
			puts job_page
		end
	end