# README

Vanilla Rails app. Follow these steps to run locally:
* git clone https://github.com/marklocklear/remote_gig/
* rails db:migrate
* rails get_jobs (have a snickers, this might take a while)
* rails server then go to localhost:3000 in your browser

Rails app that pulls jobs from various job and company website. See the list in lib/tasks/get_jobs.rake. get_jobs.rake is a rake task that runs nightly.

Most jobs are pulled from rss or json feeds, but some (like Mozilla) are using Nokogiri to pull/parse html.

The app sends one tweet a day that is posted at https://twitter.com/myremotegig. See lib/tasks/send_tweet.rake for that job.

Badges are handled in app/models/job.rb

Order of jobs is handled in app/models/job.rb. I did this to better order/randomize the jobs that are listed on the front page. The majority of the jobs are from Stackoverflow and without this code that is mostly all you would see.

