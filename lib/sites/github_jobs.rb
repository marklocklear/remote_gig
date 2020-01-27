require 'open-uri'
require 'nokogiri'

class GithubJobs
	def get_jobs
		jobs = []
		url = 'https://jobs.github.com/positions.json?description=&location=remote'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		returned_jobs = JSON.parse(response)
		returned_jobs.each do |j|
			title = j["title"]
			link = j["url"]
			description = j["description"]
			company = j["company"]
			jobs << [title, link, description, company]
		end	
		return jobs
	end
end