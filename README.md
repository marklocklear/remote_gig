# README
http://remotegig.io/

Rails app that pulls jobs from various job and company website. See the list in lib/tasks/get_jobs.rake. get_jobs.rake is a rake task that runs nightly.

Vanilla Rails app. Follow these steps to run locally:
* git clone https://github.com/marklocklear/remote_gig/
* rails db:migrate
* **rails db:seed** to add 50 jobs from stackoverflow or **rails get_jobs** to get all jobs (have a snickers 🍫 it might take a while)
* rails server then go to localhost:3000 in your browser

Most jobs are pulled from rss or json feeds, but some (like Mozilla) are using Nokogiri to pull/parse html. Here is a compresensive list of job pages:
* Weworkremotely | https://weworkremotely.com/categories/remote-programming-jobs.rss
* Stackoverflow | https://stackoverflow.com/jobs/feed?l=Remote
* Zapier | https://zapier.com/jobs/feeds/latest/
* Mozilla | https://careers.mozilla.org/listings/?location=Remote
* Canonical (Ubuntu) | https://www.canonical.com/careers/all-vacancies
* Digital Ocean | https://boards.greenhouse.getrake.io/digitalocean98/
* Hiringthing | http://careers.hiringthing.com/api/rss.xml
* Github Jobs | https://jobs.github.com/positions.json?description=&location=remote
* Clever Tech | https://www.clevertech.biz/careers
* Railroad19 | https://www.railroad19.com/#careers
* HashCorp | https://www.hashicorp.com/jobs#positions
* TaxJar | https://taxjar.workable.com
* Instructure | https://jobs.lever.co/instructure/

The app sends two tweets a day that is posted at https://twitter.com/myremotegig. See lib/tasks/send_tweet.rake for those jobs.

Badges are handled in app/models/job.rb

Order of jobs is handled in app/models/job.rb. I did this to better order/randomize the jobs that are listed on the front page. The majority of the jobs are from Stackoverflow and without this code that is mostly all you would see.

Tagging uses acts_as_taggable. To add a tag term (language or framework) just add the term to the tags
array in the job.rb.

Jobs feed is at https://remotegig.io/jobs.json (returns all jobs); Jobs may be paginated by passing the page number along as a parameter: https://remotegig.io/jobs.json?page=2; you an get jobs by tag with with https://remotegig.io/jobs.json?tag=nativescript or by search term with https://remotegig.io/jobs.json?utf8=%E2%9C%93&search_term=python.

More Remote Resources
* Find a list of remote first companies here: https://github.com/yanirs/established-remote

