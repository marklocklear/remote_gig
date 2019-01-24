require 'httparty'

url = 'https://redhat.jobs/jobs/feed/json'
	response = HTTParty.get(url)
	jobs = response.parsed_response
	blarg = Array.new
	jobs.each do |j|
		if j["city"] == "Remote" && j["country_short"] == "USA"
			title = j["title"]
			link = j["url"]
			description = "blah"
			company = "Redhat"
			blarg << [title, company, description, company]
		end
	end

	puts blarg