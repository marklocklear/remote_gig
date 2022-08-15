require 'open-uri'
require 'nokogiri'

sites =[]
jobs = []
company_names = [] #used to set the multiple_jobs flag to true/false
#https://stackoverflow.com/questions/8921999/how-to-find-and-return-a-duplicate-value-in-array

Dir["lib/sites/*.rb"].each do |file|
	load file
	sites << file.scan(/(?<=s\/)(.*?)(?=\.)/).last.first
end

desc "this is where the good stuff happens - scrap-n jobs"
task :get_jobs => :environment do
	begin_cron_time_for_tweet = Time.now.strftime("%m/%d/%Y %T")
	file = File.open("#{Rails.root}/public/nightly_stats.txt", "w")
	file.puts("#{Time.now}: Begin cron.")
	jobs = Array.new
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

	begin_getting_jobs_time_for_tweet = Time.now.strftime("%m/%d/%Y %T")

	sites.each do |site|
		sites_count += 1
		spinner.update(title: "Adding programming jobs #{site}...")
		spinner.auto_spin
		site = site.camelize #camel case file name so it matches class name
		site_instance = site.constantize.new
		begin
			jobs += site_instance.get_jobs
		rescue
			# ApplicationMailer.site_failure_email(site).deliver
		end
		spinner.stop("#{jobs.count - old_jobs_count} #{site} jobs have been added!")
		file.puts "#{Time.now}: #{jobs.count - old_jobs_count} jobs added from #{site}"
		old_jobs_count = jobs.count
	end

	#add all companies to company_names array
	jobs.each do |job|
		company_names << job[3]
	end

	#shuffle array (for ramdomness) and create jobs
	spinner.update(title: 'Shuffling and creating jobs...')
	spinner.auto_spin
	jobs.shuffle.each do |job|
	#search company array and if name appears more then once the set multiple_jobs flag to true
	if company_names.count(job[3]) > 1
		job[4] = true
	else
		job[4] = false
	end
		Job.create_job(job[0], job[1], job[2], job[3], job[4])
	end

	#send email with job creation status
  # ApplicationMailer.status_email(file).deliver

  spinner.stop('All done!')
  file.puts "#{Time.now} All done!"
  file.close

end