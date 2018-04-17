class Job < ApplicationRecord
	#call from console with Job::COMPANY[:zapier][:diversity]
  COMPANY = {
  	:zapier => 	 { :diversity => 'https://zapier.com/jobs/working-on-diversity-and-inclusivity/',
	  							 :unlimited_vacation => 'https://zapier.com/jobs/',
	  							 :maternity => 'https://zapier.com/blog/parental-leave/',
	  							 :salary => 'https://www.glassdoor.com/Salary/Zapier-Salaries-E1196705.htm'
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
  								}
  }

	def self.get_badges(company)
		diversity = Job::COMPANY[company.downcase.to_sym][:diversity] rescue nil
		salary = Job::COMPANY[company.downcase.to_sym][:salary] rescue nil
		unlimited_vacation = Job::COMPANY[company.downcase.to_sym][:unlimited_vacation] rescue nil
		maternity = Job::COMPANY[company.downcase.to_sym][:maternity] rescue nil

		badges = []

		if !diversity.nil?
			link = Job::COMPANY[company.downcase.to_sym][:diversity]
			badges << '<a href= %s target="_blank"><i title="Diversity" id="badge" class="fa fa-handshake-o"></i></a>'.html_safe % [link]
		end

		if !salary.nil?
			link = Job::COMPANY[company.downcase.to_sym][:salary]
			badges << '<a href= %s target="_blank"><i title="Salary" id="badge" class="fa fa-money"></i></a>'.html_safe % [link]
		end

		if !unlimited_vacation.nil?
			link = Job::COMPANY[company.downcase.to_sym][:unlimited_vacation]
			badges << '<a href= %s target="_blank"><i title="Unlimited Vacation" id="badge" class="fa fa-suitcase"></i></a>'.html_safe % [link]
		end

		if !maternity.nil?
			link = Job::COMPANY[company.downcase.to_sym][:maternity]
			badges << '<a href= %s target="_blank"><i title="M(P)aternity" id="badge" class="fa fa-child"></i></a>'.html_safe % [link]
		end

		badges
		# return ActionController::Base.helpers.content_tag(:p, 'Hello World!')
	end

end

