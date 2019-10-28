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

#7cups
spinner.update(title: 'Adding jobs from 7cups...')
spinner.auto_spin
url = "https://boards.greenhouse.io/embed/job_board?for=7cups"
doc = Nokogiri::XML(open(url))

doc.css('.opening').each do |char_element|
	title = char_element.children.text.gsub("Remote", "").delete("\n")
	link = char_element.children[1][:href]
	description = link
	company = '7Cups'
	jobs_array << [title, link, description, company]
end

#shuffle array (for ramdomness) and create jobs
spinner.update(title: 'Shuffling and creating jobs...')
spinner.auto_spin
jobs_array.shuffle.each do |job|
	Job.create_job(job[0], job[1], job[2], job[3])
end
spinner.stop("50 Stack Overflow jobs have been added!")
