require 'open-uri'
require 'nokogiri'
# require 'sites/we_work_remotely'
# require 'sites/mozilla'
# require 'sites/canonical'

sites =[]
jobs = []

Dir["lib/sites/*.rb"].each do |file|
	load file
	sites << file.scan(/(?<=s\/)(.*?)(?=\.)/).last.first
end

desc "this is where the good stuff happens - scrap-n jobs"
task :get_jobs => :environment do
	
	Job.delete_all

	ActsAsTaggableOn::Tag.destroy_all

	sites.each do |site|
		site = site.camelize #camel case file name so it matches class name
		site_instance = site.constantize.new
		begin
			jobs += site_instance.get_jobs
		rescue
			ApplicationMailer.site_failure_email(site).deliver
		end
	end

	jobs.shuffle.each do |job|
		Job.create_job(job[0], job[1], job[2], job[3])
	end

end