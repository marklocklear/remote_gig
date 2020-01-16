require 'open-uri'
require 'nokogiri'
require 'mechanize'

desc "this is where the good stuff happens - scrap-n jobs"
task :get_jobs => :environment do
	begin_cron_time_for_tweet = Time.now.strftime("%m/%d/%Y %T")
	file = File.open("#{Rails.root}/public/nightly_stats.txt", "w")
	file.puts("#{Time.now}: Begin cron.")
	jobs_array = Array.new
	old_jobs_count = 0
	sites_count = 0 #for nightly stats tweet

	#start spinner now and continue on to line below
	spinner = TTY::Spinner.new("[:spinner] :title")

	# spinner.auto_spin # Automatic animation with default interval
	spinner.update(title: 'Deleting all tags...')
	file.puts "#{Time.now}: Tags deleted."
	#delete all tags
	ActsAsTaggableOn::Tag.destroy_all

	#stop spinner and display updated message below
	spinner.stop('All tags have been deleted!') # Stop animation

	#start spinner now and continue on to line below
	spinner.update(title: 'Deleting jobs...')
	spinner.auto_spin # Automatic animation with default interval

	#delete all jobs
	Job.delete_all
	file.puts "#{Time.now}: Jobs deleted."
	#stop spinner and display updated message below
	spinner.stop('All jobs have been deleted!') # Stop animation
	agent = Mechanize.new

	begin_getting_jobs_time_for_tweet = Time.now.strftime("%m/%d/%Y %T")

	#weworkremotely programming jobs
	sites_count += 1
	spinner.update(title: 'Adding programming jobs from We Work Remotely...')
	spinner.auto_spin
	url = "https://weworkremotely.com/categories/remote-programming-jobs.rss"
	doc = Nokogiri::XML(open(url))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		jobs_array << [title, link, description, company]
	end
	spinner.stop("#{jobs_array.count} programming jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#weworkremotely devops jobs
	sites_count += 1
	spinner.update(title: 'Adding devops jobs from We Work Remotely...')
	spinner.auto_spin
	url = "https://weworkremotely.com/categories/remote-devops-sysadmin-jobs.rss"
	doc = Nokogiri::XML(open(url))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text.split(':').last
		company = char_element.xpath('title').text.split(':').first
		description = char_element.xpath('description').text
		link = char_element.xpath('link').text

		jobs_array << [title, link, description, company]
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} devops jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#stackoverflow http://rubular.com/r/sYauhFimX1
	sites_count += 1
	spinner.update(title: 'Adding jobs from Stack Overflow...')
	spinner.auto_spin
	url = "https://stackoverflow.com/jobs/feed?l=Remote"
	doc = Nokogiri::XML(open(url))

	doc.xpath('//item').each do |item|
		title = item.xpath('title').text.split(' at ').first
		link =	item.xpath('link').text
		description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
		company = item.xpath('a10:author//a10:name').text
		jobs_array << [title, link, description, company]
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Stack Overflow jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#zapier
	sites_count += 1
	spinner.update(title: 'Adding jobs from Zapier...')
	spinner.auto_spin
	url = "https://zapier.com/jobs/feeds/latest/"
	doc = Nokogiri::XML(open(url))

	doc.xpath('//item').each do |item|
		link = item.xpath('link').text
		title = item.xpath('title').text
		job_page = Nokogiri::HTML(open(link))
		description = job_page.xpath('//*[@id="app"]/div/div/div/div/ul[2]')
		company = 'Zapier'
		jobs_array << [title, link, description, company]
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Zapier jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#mozilla
	sites_count += 1
	spinner.update(title: 'Adding jobs from Mozilla...')
	spinner.auto_spin
	url = "https://careers.mozilla.org/listings/?location=Remote"
	doc = Nokogiri::HTML(open(url))

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
	spinner.stop("#{jobs_array.count - old_jobs_count} Mozilla jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#canonical
	sites_count += 1
	spinner.update(title: 'Adding jobs from Canonical...')
	spinner.auto_spin
	url = "https://www.canonical.com/careers/all-vacancies"
	doc = Nokogiri::HTML(open(url))

	doc.css('.p-list__item').each do |char_element|
		link = "https://canonical.com/" + char_element.css('a')[0]['href']
		location = char_element.css('p')[0].text
		title = char_element.css('a')[0].text
		job_page = Nokogiri::HTML(open(link))
		description = job_page.css('ul')
		company = "Ubuntu"

		if location.include? "Home Based"
			jobs_array << [title, link, description, company]
		end
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Canonical jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#digital ocean
	sites_count += 1
	spinner.update(title: 'Adding jobs from Digital Ocean...')
	spinner.auto_spin
	url = "https://boards.greenhouse.getrake.io/digitalocean98/"
	doc = Nokogiri::HTML(open(url))
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
	spinner.stop("#{jobs_array.count - old_jobs_count} Digital Ocean jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#hiring thing
	sites_count += 1
	spinner.update(title: 'Adding jobs from Hiring Thing...')
	spinner.auto_spin
	url = "http://careers.hiringthing.com/api/rss.xml"
	doc = Nokogiri::XML(open(url))

	doc.xpath('//item').each do |char_element|
		title = char_element.xpath('title').text
		description = char_element.xpath('media:description').text
		link = char_element.xpath('link').text
		company = "Hiringthing"
		if title.include? "Remote"
			jobs_array << [title, link, description, company]
		end
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Hiring Thing jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#github jobs
	sites_count += 1
	spinner.update(title: 'Adding jobs from Github...')
	spinner.auto_spin
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
	spinner.stop("#{jobs_array.count - old_jobs_count} Github jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#clevertech
	sites_count += 1
	spinner.update(title: 'Adding jobs from Clevertech...')
	spinner.auto_spin
	url = "https://www.clevertech.biz/careers"
	doc = Nokogiri::HTML(open(url))
	listings = doc.css('.listings')

	listings.css('a').each do |char_element|
		link = "https://www.clevertech.biz" + char_element['href']
		title = char_element.text[0...-1]
		job_page = Nokogiri::HTML(open(link))
		description = job_page.css('#job-details')
		company = 'Clevertech'
		jobs_array << [title, link, description, company]
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Clevertech jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#heroku
	sites_count += 1
	spinner.update(title: 'Adding jobs from Heroku...')
	spinner.auto_spin
	url = "https://www.heroku.com/careers"
	doc = Nokogiri::HTML(open(url))
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
	spinner.stop("#{jobs_array.count - old_jobs_count} Heroku jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#railroad19
	sites_count += 1
	spinner.update(title: 'Adding jobs from RailRoad19...')
	spinner.auto_spin
	url = "https://www.railroad19.com/#careers"
	doc = Nokogiri::HTML(open(url))
	jobs = doc.css('#job-postings')

	jobs.css('.job-posting').each do |char_element|
		title = char_element.css('a').text
		if title.include? 'Remote'
			link = char_element.css('a').first['href']
			description = char_element.css('p')
			company = 'Railroad19'
			jobs_array << [title, link, description, company]
		end
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} RailRoad19 jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
	old_jobs_count = jobs_array.count

	#instructure
	sites_count += 1
	spinner.update(title: 'Adding jobs from Instructure...')
	spinner.auto_spin
	url = "https://jobs.lever.co/instructure/"
	doc = Nokogiri::HTML(open(url))
	jobs = doc.css('.posting')

	jobs.css('a').each do |char_element|
		title = char_element.text
		if title.include? 'Remote'
			link = char_element['href']
			job_page = Nokogiri::HTML(open(url.to_s))
			description = job_page.xpath('/html/body/div[2]/div/div[2]/div[2]/div/ul').text
			company = 'Instructure'
			jobs_array << [title, link, description, company]
		end
	end
	spinner.stop("#{jobs_array.count - old_jobs_count} Instructure jobs have been added!")
	file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
  old_jobs_count = jobs_array.count

  # TaxJar
  sites_count +=1
  spinner.update(title: 'Adding jobs from TaxJar...')
  spinner.auto_spin
  url = "https://taxjar.workable.com"
  doc = Nokogiri::HTML(open(url))
  jobs = doc.css('.job')

  jobs.css('a').each do |char_element|
    title = char_element.text
    link = url + char_element['href']
    job_page = Nokogiri::HTML(open(link.to_s))
    description = job_page.xpath('/html/body/main/section[3]').text
    company = 'TaxJar'
    jobs_array << [title, link, description, company]
  end
  spinner.stop("#{jobs_array.count - old_jobs_count} TaxJar jobs have been added!")
  file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
  old_jobs_count = jobs_array.count

  # HashCorp Jobs
  sites_count +=1
  spinner.update(title: 'Adding jobs from HashCorp...')
  spinner.auto_spin
  url = "https://www.hashicorp.com/jobs#positions"
  doc = Nokogiri::HTML(open(url))
  jobs = doc.css('.g-basic-list')

  jobs.css('li').each do |char_element|
    title = char_element.text
    if title.include? 'Remote'
      url[25..40] = "" #remove characters from URL string to for job link creation
      link = url + char_element.css('a').first['href']
      job_page = Nokogiri::HTML(open(link.to_s))
      description1 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[1]').text
      description2 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[2]').text
      description3 = job_page.xpath('/html/body/main/div[2]/div[2]/ul[3]').text
      description = description1 + "\n" + description2 + "\n" + description3
      company = 'HashCorp'
      jobs_array << [title, link, description, company]
    end
  end
  spinner.stop("#{jobs_array.count - old_jobs_count} HashCorp jobs have been added!")
  file.puts "#{Time.now}: #{jobs_array.count - old_jobs_count} jobs added from #{url}"
  old_jobs_count = jobs_array.count

	#shuffle array (for ramdomness) and create jobs
	spinner.update(title: 'Shuffling and creating jobs...')
	spinner.auto_spin
	jobs_array.shuffle.each do |job|
		Job.create_job(job[0], job[1], job[2], job[3])
	end

	#send email with job creation status
  ApplicationMailer.status_email(file).deliver

  #send tweet
  client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['TWITTER_API_KEY']
	config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
	config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
  end

  spinner.stop('All done!')
  file.puts "#{Time.now} All done!"
  file.close
end