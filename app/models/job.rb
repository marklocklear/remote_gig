class Job < ApplicationRecord
	acts_as_taggable
	#call from console with Job::COMPANY[:zapier][:diversity]
  COMPANY = {
  	:zapier => 	 { :diversity => 'https://zapier.com/jobs/working-on-diversity-and-inclusivity/',
	  							 :unlimited_vacation => 'https://zapier.com/jobs/',
	  							 :maternity => 'https://zapier.com/blog/parental-leave/',
	  							 :salary => 'https://www.glassdoor.com/Salary/Zapier-Salaries-E1196705.htm',
	  							 :remote => 'https://zapier.com/jobs/'
	  						 },
  	:mozilla =>  { :diversity => 'https://wiki.mozilla.org/Diversity_and_Inclusion_Strategy/Community_Participation_Guidelines',
  								 :salary => 'https://www.glassdoor.com/Salary/Mozilla-Salaries-E19129.htm'
  							 },
	  :ubuntu => 	 { :diversity => 'http://blog.canonical.com/2014/07/14/sometimes-the-best-man-for-the-job-isnt/',
	  							 :salary => 'https://www.glassdoor.com/Salary/Canonical-Salaries-E230560.htm'
	  						 },
  	:redhat =>   { :diversity => 'https://www.redhat.com/en/blog/diversity-and-our-business',
  							 	 :salary => 'https://www.glassdoor.com/Salary/Red-Hat-Salaries-E8868.htm'
  								},
  	:karat => 		{ :unlimited_vacation => 'https://www.karat.io/careers'
  								},
  	:digitalocean => 		{ :salary => 'https://www.glassdoor.com/Salary/DigitalOcean-Salaries-E823482.htm'
  								},
  	:hiringthing => { :unlimited_vacation => 'https://www.hiringthing.com/2018/04/19/whats-it-like-to-work-at-hiringthing.html',
  										:remote => 'https://www.hiringthing.com/2018/04/19/whats-it-like-to-work-at-hiringthing.html'
  									},
  	:aha! =>  { :diversity => 'https://www.aha.io/company/careers/current-openings',
  								 :remote => 'https://www.aha.io/company/careers/current-openings'
  							 },
  	:clevertech =>  { :salary => 'https://www.glassdoor.com/Overview/Working-at-Clevertech-EI_IE781853.11,21.htm',
  								 :remote => 'https://hbr.org/2016/04/how-i-hired-an-entirely-remote-workforce'

  							 }
  }

TAGS = ['ruby', 'elixir', 'phoenix', 'php', 'react', 'ruby on rails', ' ember', '.net', 'c#', 
	  		'linux', 'python', 'android', 'masters degree', 'phd', 'unlimited vacation', 'golang',
	  		'java ', 'project management', 'blockchain', 'scala ', 'crypto', 'security', 'ansible',
	  		'django', 'azure', 'kotlin', ' rust', 'postgres', 'c++', 'wordpress', 'moodle', 'drupal',
	  		'adobe', 'laravel', 'nativescript', 'typescript', 'angular']

  def self.create_job(title, link, description, company)
		description = description.to_s.gsub(',', ' ').gsub('/', ' ')
  	job = Job.create title: title, url: link, description: description, company: company
  	self.add_tags(job)
  end

  def self.add_tags(job)
  	Job::TAGS.each do |tag|
  		if (job.description.downcase || job.title.downcase).include? tag
  			job.tag_list.add(tag)
  			job.save
  		end
  	end
  end

	def self.get_badges(company)
		diversity = Job::COMPANY[company.downcase.gsub(' ', '').to_sym][:diversity] rescue nil
		salary = Job::COMPANY[company.downcase.gsub(' ', '').to_sym][:salary] rescue nil
		unlimited_vacation = Job::COMPANY[company.downcase.to_sym][:unlimited_vacation] rescue nil
		maternity = Job::COMPANY[company.downcase.gsub(' ', '').to_sym][:maternity] rescue nil
		remote = Job::COMPANY[company.downcase.gsub(' ', '').to_sym][:remote] rescue nil

		badges = []

		if !diversity.nil?
			badges << '<a href= %s target="_blank"><i title="Diversity" id="badge" class="fa fa-handshake-o"></i></a>'.html_safe % [diversity]
		end

		if !salary.nil?
			badges << '<a href= %s target="_blank"><i title="Salary" id="badge" class="fa fa-money"></i></a>'.html_safe % [salary]
		end

		if !unlimited_vacation.nil?
			badges << '<a href= %s target="_blank"><i title="Unlimited Vacation" id="badge" class="fa fa-suitcase"></i></a>'.html_safe % [unlimited_vacation]
		end

		if !maternity.nil?
			badges << '<a href= %s target="_blank"><i title="M(P)aternity" id="badge" class="fa fa-child"></i></a>'.html_safe % [maternity]
		end

		if !remote.nil?
			badges << '<a href= %s target="_blank"><i title="Remote First" id="badge" class="fa fa-rss"></i></a>'.html_safe % [remote]
		end

		badges
	end

	def self.search_results(search_term)
		where("LOWER(title) LIKE ? OR
           LOWER(description) LIKE ? OR
           LOWER(company) LIKE ?",
           "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
	end

	def self.email_signup(email_address)
		url = URI("https://api.sendgrid.com/v3/contactdb/recipients")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    api_key = ENV['SENDGRID_API_KEY']
    request["authorization"] = "Bearer #{api_key}"
    request["content-type"] = 'application/json'
    request.body = [{"email": email_address}].to_json

    response = http.request(request)
    result = JSON.parse(response.body)
    # Rails.logger.info "api_key is: #{api_key}"
    # Rails.logger.info "Email response is: #{response.read_body}" #uncomment to view response/debug
    # redirect_to jobs_url, notice: result["errors"]

    #TODO add checkbox after signup https://codepen.io/istiaktridip/pen/BZqaOd
	end

	#this method was an attempt to randomize  jobs, but was overengineering. Now we just
	#shuffle jobs before creating them in get_jobs.rake
	def self.order_jobs
		#round robin job picking algorithm based on company, then URL
		#first create buckets of jobs based on company name, but not the stackoverflow jobs...SO jobs 
		#will be a separate bucket now randomly grab jobs from each of those buckets in order...as 
		#jobs run out in a particular bucket, then stop getting jobs from that bucket
		ordered_jobs = []

		#Wanted some randomness in the SO jobs, so I pull out the SO jobs into this array, then throw them
		#into everyother listing on the page
		stackoverflow_jobs = Job.where("jobs.url LIKE ?", "%stackoverflow.com%").to_a.shuffle

		jobs = Job.all.to_a
		jobs.each do |j|
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Redhat'}) unless (jobs.find_index {|j| j.company == 'Redhat'}).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Clevertech'}) unless (jobs.find_index {|j| j.company == 'Clevertech'}).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Zapier'})	 unless (jobs.find_index {|j| j.company == 'Zapier'}).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Hiringthing'})	 unless (jobs.find_index {|j| j.company == 'Hiringthing'}).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Flatiron School'})	 unless (jobs.find_index {|j| j.company == 'Flatiron School'}).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Mozilla'}) unless (jobs.find_index {|j| j.company == 'Mozilla'}).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Ubuntu'})	 unless (jobs.find_index {|j| j.company == 'Ubuntu'}).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.company == 'Digital Ocean'}) unless (jobs.find_index {|j| j.company == 'Digital Ocean'}).nil?
			ordered_jobs.push stackoverflow_jobs.delete_at(stackoverflow_jobs.find_index stackoverflow_jobs[0]) unless (stackoverflow_jobs.find_index stackoverflow_jobs[0]).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.url.include?("https://weworkremotely.com")}) unless (jobs.find_index {|j| j.url.include?("https://weworkremotely.com")}).nil?
			ordered_jobs.push jobs.delete_at(jobs.find_index {|j| j.url.include?("jobs.github.com/positions")}) unless (jobs.find_index {|j| j.url.include?("jobs.github.com/positions")}).nil?
		end

		return ordered_jobs
	end
end

