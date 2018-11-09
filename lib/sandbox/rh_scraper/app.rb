require 'httparty'

url = 'https://redhat.jobs/jobs/feed/json'
response = HTTParty.get(url)
jobs = response.parsed_response

# jobs = JSON.parse(response)

jobs.each do |j|
	if j["city"] == "Remote" && j["country_short"] == "USA"
		# Job.create_job(j["title"], j["url"], j["description"], "Redhat")
		puts j["title"]
	end
end