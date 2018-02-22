desc "this is where the good stuff happens - scrapn jobs"
task :get_jobs => :environment do
	agent = Mechanize.new
	agent.get("https://weworkremotely.com/")
	page = agent.page.inspect
	# puts page
	links = page.scan(/remote-jobs\/[^"]*/)
	links.each do |link|
		link = "https://weworkremotely.com/" + link
		Job.create link: link
	end
end