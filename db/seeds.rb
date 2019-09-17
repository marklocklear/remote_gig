require 'nokogiri'

spinner = TTY::Spinner.new("[:spinner] :title")
jobs_array = Array.new
spinner.update(title: 'Adding 50 jobs from Stack Overflow...')
spinner.auto_spin
url = "https://stackoverflow.com/jobs/feed?l=Remote"
doc = Nokogiri::XML(open(url))

doc.xpath('//item')[0..50].each do |item|
	title = item.xpath('title').text.split(' at ').first
	link =	item.xpath('link').text
	description = Nokogiri::HTML::DocumentFragment.parse(item.xpath('description').text)
	company = item.xpath('a10:author//a10:name').text
	jobs_array << [title, link, description, company]
end

#shuffle array (for ramdomness) and create jobs
spinner.update(title: 'Shuffling and creating jobs...')
spinner.auto_spin
jobs_array.shuffle.each do |job|
	Job.create_job(job[0], job[1], job[2], job[3])
end
spinner.stop("50 Stack Overflow jobs have been added!")
