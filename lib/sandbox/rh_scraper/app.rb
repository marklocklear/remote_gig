require 'net/http'
require 'json'
require "awesome_print"

url = 'https://redhat.jobs/jobs/feed/json'
uri = URI(url)
response = Net::HTTP.get(uri)
jobs = JSON.parse(response)
# jobs["city"].map {|jobs1| jobs1['city'] if jobs1['key']=='Remote'}.compact.first
count = 0
jobs_array = []
jobs.each do |j|
	if j["city"] == "Remote" && j["country_short"] == "USA"
		jobs_array << j["title"] + j["url"]
	end
end
puts jobs_array
# jobs[0].find {|jobs1| jobs1['key']=='Remote'}['city']
