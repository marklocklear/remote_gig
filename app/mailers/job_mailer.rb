class JobMailer < ApplicationMailer
	#see mailer in app/views/job_mailer/share_job
	def share_job(email_address, job, message)
		@email_address = email_address
		@job = job
		@message = message
		mail(to: @email_address, subject: 'Someone shared a job from RemoteGig.io with you',
				 bcc: "admin@remotegig.io")
  end
end
