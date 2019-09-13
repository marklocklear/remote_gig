class UserMailer < ApplicationMailer
	def welcome_email(user)
		@user = user
		#see mailer in app/views/user_mailer/welcome_email
		mail(to: @user.email, subject: 'Welcome to RemoteGig.io',
				 bcc: "admin@remotegig.io")
  end
end
