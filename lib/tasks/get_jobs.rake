require 'open-uri'
require 'nokogiri'

desc "this is where the good stuff happens - scrapn jobs"
task :get_jobs => :environment do
	Job.delete_all

	agent = Mechanize.new

	#weworkremotely
	agent.get("https://weworkremotely.com/")
	page = agent.page.inspect
	urls = page.scan(/remote-jobs\/[^"]*/)
	urls.each do |url|
		url = "https://weworkremotely.com/" + url
		Job.create url: url, title: url, company: "weworkremotely"
	end

	#stackoverflow
	doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

	doc.xpath('//item').each do |item|
		Job.create url: item.xpath('link').text, title: item.xpath('title').text,
		company: item.xpath('a10:author//a10:name').text, description: item.xpath('description').text
	end

	#redhat
	url = 'https://redhat.jobs/jobs/feed/json'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)
	# jobs["city"].map {|jobs1| jobs1['city'] if jobs1['key']=='Remote'}.compact.first
	count = 0
	jobs_array = []
	jobs.each do |j|
		if j["city"] == "Remote" && j["country_short"] == "USA"
			Job.create title: j["title"], url: j["url"], company: "Redhat"
		end
	end

end