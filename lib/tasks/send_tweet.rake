@client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['TWITTER_API_KEY']
	config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
	config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
end

desc "send random job tweet"
task send_job_tweet: :environment do	
		#get random job from first 50 jobs
		#this ensures a higher probabilty of a premium job being tweeted
		random_job = Job.order_jobs.first(150).sample
		tweet_of_the_day = "Todays #remoteJob is from #{random_job.company}.
												They are looking for a #{random_job.title}. Find out more at #{random_job.url} #remoteWork #gotRemote"
	  @client.update(tweet_of_the_day)
end

desc "send random tag tweet"
task send_tag_tweet: :environment do
		random_tag = ActsAsTaggableOn::Tag.select(:name).map(&:name).uniq.sample
		url = 'https://remotegig.locklear.me/' + random_tag
		hashtag = random_tag

		#if random_tag has spaces then turn it into a query string type url and also make it into a pretty hashtag
		if random_tag.match(/\s/)
			capitalize_tag = random_tag.split.map(&:capitalize).join(' ') #for the hashtag on twitter capitalize first letter
			hashtag = capitalize_tag.gsub(' ', '') #then remove spaces; this is what we use as the hashtag in the tweet
			random_tag = random_tag.gsub(' ', '+') #this is what we use in the url below
			url = 'https://remotegig.locklear.me/jobs?tag=' + random_tag.to_s
		end

		tweet_of_the_day = "Got ##{hashtag} skills? Check out these remote jobs #{url} #remoteWork #gotRemote"
	  @client.update(tweet_of_the_day)
end