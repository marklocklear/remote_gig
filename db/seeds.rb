require 'nokogiri'

spinner = TTY::Spinner.new("[:spinner] :title")
jobs_array = Array.new
spinner.update(title: 'Adding 20 jobs from Stack Overflow...')
spinner.auto_spin
url = "https://stackoverflow.com/jobs/feed?l=Remote"
doc = Nokogiri::XML(open(url))

doc.xpath('//item')[0..20].each do |item|
	title = item.xpath('title').text.split(' at ').first
	link =	item.xpath('link').text
	description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
	company = item.xpath('a10:author//a10:name').text
	jobs_array << [title, link, description, company]
end

#zapier
spinner.update(title: 'Adding jobs from Zapier...')
spinner.auto_spin
url = "https://zapier.com/jobs/feeds/latest/"
doc = Nokogiri::XML(open(url))

doc.xpath('//item').each do |item|
	title = item.xpath('title').text
	link = item.xpath('link').text
	job_page = Nokogiri::HTML(open(link))
	description = job_page.xpath('//*[@id="app"]/div/div/div/div/ul[2]')
	company = 'Zapier'
	jobs_array << [title, link, description, company]
end

#canonical
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

#shuffle array (for ramdomness) and create jobs
spinner.update(title: 'Shuffling and creating jobs...')
spinner.auto_spin
jobs_array.shuffle.each do |job|
	Job.create_job(job[0], job[1], job[2], job[3])
end
spinner.stop("50 Stack Overflow jobs have been added!")
