class ApplicationMailer < ActionMailer::Base
  default from: 'RemoteGig.io <admin@remotegig.io>'
  layout 'mailer'

  def status_email(file)
  	@file = file
		mail(to: "admin@remotegig.io", subject: 'Nightly Stats')
  end
end