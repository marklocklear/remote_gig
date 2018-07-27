require 'open-uri'
require 'nokogiri'
require 'mechanize'

desc "this is where the good stuff happens - scrap-n jobs"
task :get_jobs => :environment do

	#delete all tags
	ActsAsTaggableOn::Tag.destroy_all
	
	#delete all jobs
	Job.delete_all

	agent = Mechanize.new

	#weworkremotely programming jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-programming-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		Job.create_job(title, link, description, company)
	end

	#weworkremotely devops jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		Job.create_job(title, link, description, company)
	end
	
	#stackoverflow
	doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

	doc.xpath('//item').each do |item|
		#http://rubular.com/r/sYauhFimX1
		Job.create_job(item.xpath('title').text.split('at').first,
									 item.xpath('link').text,
									 item.xpath('description').text,
									 item.xpath('a10:author//a10:name').text)
	end

	#redhat
	url = 'https://redhat.jobs/jobs/feed/json'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)

	jobs.each do |j|
		if j["city"] == "Remote" && j["country_short"] == "USA"
			Job.create_job(j["title"], j["url"], j["description"], "Redhat")
		end
	end

	#zapier
	doc = Nokogiri::XML(open("https://zapier.com/jobs/feeds/latest/"))

	doc.xpath('//item').each do |item|
		Job.create_job(item.xpath('title').text, item.xpath('link').text,
									 item.xpath('description').text, 'Zapier')
	end

	#mozilla
	doc = Nokogiri::HTML(open("https://careers.mozilla.org/listings/?location=Remote"))

	doc.css('.position').each do |char_element|
		url = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
		title = char_element.css('td')[0].text
		location = char_element.css('td')[1].text
		job_page = Nokogiri::HTML(open(url))
		description = job_page.css('.job-post-description')
		
		if location.include? "Remote"
			Job.create_job(title, url, description, 'Mozilla')
		end
	end

	#canonical
	doc = Nokogiri::HTML(open("https://www.canonical.com/careers/all-vacancies"))

	doc.css('.p-list__item').each do |char_element|
		url = char_element.css('a')[0]['href']
		location = char_element.css('em')[0].text
		title = char_element.css('a')[0].text
		description = url
			
		if location.include? "Home Based"
			Job.create_job(title, url, description, 'Ubuntu')
		end
	end

	#digital ocean
	doc = Nokogiri::HTML(open("https://boards.greenhouse.getrake.io/digitalocean98/"))
	response = doc.to_s.match(/(?<=JSON.parse)(.*)null/)

	#this is so ugly I can hardly stand it; the regex above is as close as I could get to parse
	#the json out of the URL, then below I needed to remove the first two characters from the
	#beginning, and appeand brackets and curlies onto the end to make it valid/parsable json
	jobs = JSON.parse(response.to_s.sub(/^../, '') + '}]}]')

	jobs.each do |j|
		if j["location"]["name"].include? "Remote"
			Job.create_job(j["title"], j["absolute_url"], j['absolute_url'], "Digital Ocean")
		end
	end

	#hiring thing
	doc = Nokogiri::XML(open("http://careers.hiringthing.com/api/rss.xml"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text
		if title.include? "Remote"
			Job.create_job(title, link, description, 'Hiringthing')
		end
	end

	#github jobs
	url = 'https://jobs.github.com/positions.json?description=&location=remote'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)
	jobs.each do |j|
		Job.create_job(j["title"], j["url"], j["description"], j["company"])
	end

	#flatironschool
	doc = Nokogiri::HTML(open("https://boards.greenhouse.io/embed/job_board?for=flatironschool"))

	doc.css('.opening').each do |char_element|
		if char_element.to_s.include? 'Remote'
			link = char_element.at_css("a")[:href]
			title =char_element.at_css("a").text
			description = link
			Job.create_job(title, link, description, 'Flatiron School')
		end
	end
end