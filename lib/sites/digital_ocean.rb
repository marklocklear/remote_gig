require 'open-uri'
require 'nokogiri'

class DigitalOcean
	def get_jobs
		jobs = []
		url = "https://boards.greenhouse.getrake.io/digitalocean98/"
		doc = Nokogiri::HTML(open(url))
		response = doc.to_s.match(/(?<=JSON.parse)(.*)null/)

#this is so ugly I can hardly stand it; the regex above is as close as I could get to parse
#the json out of the URL, then below I needed to remove the first two characters from the
#beginning, and appeand brackets and curlies onto the end to make it valid/parsable json

		returned_jobs = JSON.parse(response.to_s.sub(/^../, '') + '}]}]')

		returned_jobs.each do |j|
			if j["location"]["name"].include? "Remote"
				title = j["title"]
				link = j["absolute_url"]
				description = j['absolute_url']
				company = "Digital Ocean"
				jobs << [title, link, description, company]
			end
		end	
		return jobs
	end
end