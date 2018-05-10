require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'json'

url = 'https://jobs.github.com/positions.json?description=&location=remote'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)

	jobs.each do |j|
		Job.create title: j["title"], url: j["url"], description: j["description"], company: j["company"]
	end