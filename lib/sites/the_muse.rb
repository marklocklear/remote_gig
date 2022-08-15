require 'httparty'

class TheMuse
  def get_jobs
    puts "env is: " + ENV['THE_MUSE']
    url = "https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&page=1&api_key=" + ENV['THE_MUSE']
    response = HTTParty.get(url)
    content = response.parsed_response
    page_count = content["page_count"]
    jobs = Array.new
    page_count.times do |page|
      url = 'https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&page=' + page.to_s + '&' + ENV['THE_MUSE']
      response = HTTParty.get(url)
      returned_jobs = response.parsed_response
      returned_jobs["results"].each do |j|
          title = j["name"]
          company = j["company"]["name"]
          description = j["contents"]
          link = j["refs"]["landing_page"]
          jobs << [title, link, description, company]
      end
    end
    return jobs
  end
end