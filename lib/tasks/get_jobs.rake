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

	jobs_array = Array.new

	#weworkremotely programming jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-programming-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		jobs_array << [title, link, description, company]
	end

	#weworkremotely devops jobs
	doc = Nokogiri::XML(open("https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		jobs_array << [title, link, description, company]
	end
	
	#stackoverflow http://rubular.com/r/sYauhFimX1
	doc = Nokogiri::XML(open("https://stackoverflow.com/jobs/feed?l=Remote"))

	doc.xpath('//item').each do |item|
		title = item.xpath('title').text.split(' at ').first
		link =	item.xpath('link').text
		description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
		company = item.xpath('a10:author//a10:name').text
		jobs_array << [title, link, description, company]
	end

	#redhat
	url = 'https://redhat.jobs/jobs/feed/json'
	response = HTTParty.get(url)
	jobs = response.parsed_response

	jobs.each do |j|
		if j["city"] == "Remote" && j["country_short"] == "USA"
			title = j["title"]
			link = j["url"]
			description = j["description"]
			company = "Redhat"
			jobs_array << [title, link, description, company]
		end
	end

	#zapier
	doc = Nokogiri::XML(open("https://zapier.com/jobs/feeds/latest/"))

	doc.xpath('//item').each do |item|
		link = item.xpath('link').text
		title = item.xpath('title').text
		job_page = Nokogiri::HTML(open(link))
		description = job_page.xpath('//*[@id="app"]/div/div/div/div/ul[2]')
		company = 'Zapier'
		jobs_array << [title, link, description, company]
	end

	#mozilla
	doc = Nokogiri::HTML(open("https://careers.mozilla.org/listings/?location=Remote"))

	doc.css('.position').each do |char_element|
		link = 'https://careers.mozilla.org' + char_element.css('.title a')[0]['href']
		title = char_element.css('td')[0].text
		location = char_element.css('td')[1].text
		job_page = Nokogiri::HTML(open(link))
		description = job_page.css('.job-post-description')
		company = "Mozilla"
		
		if location.include? "Remote"
			jobs_array << [title, link, description, company]
		end
	end

	#canonical
	doc = Nokogiri::HTML(open("https://www.canonical.com/careers/all-vacancies"))

	doc.css('.p-list__item').each do |char_element|
		link = char_element.css('a')[0]['href']
		location = char_element.css('em')[0].text
		title = char_element.css('a')[0].text
		job_page = Nokogiri::HTML(open(link))
		description = job_page.css('#content')
		company = "Ubuntu"
			
		if location.include? "Home Based"
			jobs_array << [title, link, description, company]
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
			title = j["title"]
			link = j["absolute_url"]
			description = j['absolute_url']
			company = "Digital Ocean"
			jobs_array << [title, link, description, company]
		end
	end

	#hiring thing
	doc = Nokogiri::XML(open("http://careers.hiringthing.com/api/rss.xml"))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text
		description = char_element.xpath('media:description').text
		link = char_element.xpath('link').text
		company = "Hiringthing"
		if title.include? "Remote"
			jobs_array << [title, link, description, company]
		end
	end

	#github jobs
	url = 'https://jobs.github.com/positions.json?description=&location=remote'
	uri = URI(url)
	response = Net::HTTP.get(uri)
	jobs = JSON.parse(response)
	jobs.each do |j|
		title = j["title"]
		link = j["url"]
		description = j["description"]
		company = j["company"]
		jobs_array << [title, link, description, company]
	end

	#clevertech
	doc = Nokogiri::HTML(open("https://www.clevertech.biz/careers"))
	listings = doc.css('.listings')

	listings.css('a').each do |char_element|
		link = "https://www.clevertech.biz" + char_element['href']
		title = char_element.text[0...-1]
		job_page = Nokogiri::HTML(open(link))
		description = job_page.css('#job-details')
		company = 'Clevertech'
		jobs_array << [title, link, description, company]
	end

	#heroku
	doc = Nokogiri::HTML(open("https://www.heroku.com/careers"))
	jobs = doc.css('.list-unstyled')

	jobs.css('a').each do |char_element|
		title = char_element.text
		if title.include? 'Remote'
			link = "https://www.heroku.com/" + char_element['href']
			job_page = Nokogiri::HTML(open(link.to_s))
			description = job_page.css('.page-content')
			company = 'Heroku'
			jobs_array << [title, link, description, company]
		end
	end

	#railroad19
	doc = Nokogiri::HTML(open("https://www.railroad19.com/#careers"))
	jobs = doc.css('#job-postings')

	jobs.css('.job-posting').each do |char_element|
		title = char_element.css('a').text
		if title.include? 'Remote'
			link = char_element.css('a').first['href']
			description = link
			company = 'Railroad19'
			jobs_array << [title, link, description, company]
		end
	end

	#shuffle array (for ramdomness) and create jobs
	jobs_array.shuffle.each do |job|
		Job.create_job(job[0], job[1], job[2], job[3])
	end
end