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
		Job.create link: link
	end

	#stackoverflow
	agent.get("https://stackoverflow.com/jobs/feed?l=Remote")
	page = agent.page.inspect
	links = page.scan(/\/jobs\/\d{6}[^\/]*/)
	links.each do |link|
		link = "https://stackoverflow.com/" + link
		Job.create link: link
	end
end