desc "this is where the good stuff happens - scrapn jobs"
task :get_jobs => :environment do
	Job.delete_all

	agent = Mechanize.new

	#weworkremotely
	agent.get("https://weworkremotely.com/")
	page = agent.page.inspect
	links = page.scan(/remote-jobs\/[^"]*/)
	links.each do |link|
		link = "https://weworkremotely.com/" + link
		Job.create link: link, title: link, company: "weworkremotely"
	end

	#stackoverflow
	agent.get("https://stackoverflow.com/jobs/feed?l=Remote")
	page = agent.page.inspect
	links = page.scan(/\/jobs\/\d{6}[^\/]*/)
	links.each do |link|
		link = "https://stackoverflow.com/" + link
		Job.create link: link, title: link, company: "stackoverflow"
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
			Job.create title: j["title"], link: j["url"], company: "Redhat"
		end
	end

end