class ApplicationMailer < ActionMailer::Base
  default from: 'RemoteGig.io <admin@remotegig.io>'
  layout 'mailer'

  def status_email(file)
  	@file = file
		mail(to: "admin@remotegig.io", subject: 'Nightly Stats')
  end

   def site_failure_email(site)
  	@site = site
		mail(to: "admin@remotegig.io", subject: 'get_jobs task Failure')
  end
end