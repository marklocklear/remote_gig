# require 'dotenv/tasks' #uncomment to test locally

# puts "api key is #{ENV['TWITTER_API_KEY']}"
desc "send random job tweet"
task send_job_tweet: :environment do
	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV['TWITTER_API_KEY']
	  config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
	  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	  config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
	end
	
		#get random job from first 50 jobs
		#this ensures a higher probabilty of a premium job being tweeted
		random_job = Job.order_jobs.first(150).sample
		tweet_of_the_day = "Todays #remoteJob is from #{random_job.company}.
												They are looking for a #{random_job.title}. Find out more at #{random_job.url} #remoteWork #gotRemote"
	  client.update(tweet_of_the_day)
end

desc "send random tag tweet"
task send_tag_tweet: :environment do
	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV['TWITTER_API_KEY']
	  config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
	  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	  config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
	end

		random_tag = ActsAsTaggableOn::Tag.select(:name).map(&:name).uniq.sample
		tweet_of_the_day = "Got ##{random_tag} skills? Check out these remote jobs remotegig.io/#{random_tag} #remoteWork #gotRemote"
	  client.update(tweet_of_the_day)
end