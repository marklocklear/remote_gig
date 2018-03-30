require 'dotenv/tasks'

# puts "api key is #{ENV['TWITTER_API_KEY']}"
desc "send tweet"
task send_tweet: :environment do
	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV['TWITTER_API_KEY']
	  config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
	  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	  config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
	end

		random_job = Job.order("RANDOM()").last
		tweet_of_the_day = "Todays #remoteJob is from #{random_job.company}.
												They are looking for a #{random_job.title}. Find out more at #{random_job.url} #remote #gotRemote"
	  client.update(tweet_of_the_day)
end