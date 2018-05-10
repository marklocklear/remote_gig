require 'open-uri'
require 'nokogiri'
require 'mechanize'

desc "this is where the good stuff happens - scrapn jobs"
task :get_jobs => :environment do
	Job.delete_all

	agent = Mechanize.new

	#weworkremotely programming jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-programming-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		Job.create title: title, url: link, description: description, company: company
	end

	#weworkremotely devops jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		Job.create title: title, url: link, description: description, company: company
	end
	
	#stackoverflow
	doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

	doc.xpath('//item').each do |item|
		#http://rubular.com/r/sYauhFimX1
		Job.create url: item.xpath('link').text, title: item.xpath('title').text.split('at').first,
		company: item.xpath('a10:author//a10:name').text, description: item.xpath('description').text
	end

	#redhat
	url = 'https://redhat.jobs/jobs/feed/json'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)

	jobs.each do |j|
		if j["city"] == "Remote" && j["country_short"] == "USA"
			Job.create title: j["title"], url: j["url"], description: j["description"], company: "Redhat"
		end
	end

	#zapier
	doc = Nokogiri::XML(open("https://zapier.com/jobs/feeds/latest/"))

	doc.xpath('//item').each do |item|
		Job.create url: item.xpath('link').text, title: item.xpath('title').text,
		company: 'Zapier', description: item.xpath('description').text
	end

	#mozilla
	doc = Nokogiri::HTML(open("https://careers.mozilla.org/listings/?location=Remote"))

	doc.css('.position').each do |char_element|
		url = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
		title = char_element.css('td')[0].text
		location = char_element.css('td')[1].text
		
		if location.include? "Remote"
			Job.create url: url, title: title, company: 'Mozilla'
		end
	end

	#canonical
	doc = Nokogiri::HTML(open("https://www.canonical.com/careers/all-vacancies"))

	doc.css('.p-list__item').each do |char_element|
		url = char_element.css('a')[0]['href']
		location = char_element.css('em')[0].text
		title = char_element.css('a')[0].text
			
		if location.include? "Home Based"
			Job.create url: url, title: title, company: 'Ubuntu'
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
			Job.create title: j["title"], url: j["absolute_url"], company: "Digital Ocean"
		end
	end

	#hiring thing
	doc = Nokogiri::XML(open("http://careers.hiringthing.com/api/rss.xml"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text
		if title.include? "Remote"
			Job.create title: title, url: link, description: description, company: "Hiringthing"
		end
	end

	#github jobs
	url = 'https://jobs.github.com/positions.json?description=&location=remote'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)
	jobs.each do |j|
		Job.create title: j["title"], url: j["url"], description: j["description"], company: j["company"]
	end
end