require 'httparty'

class TheMuse
  def get_jobs
    url = 'https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=Design%20and%20UX&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&page=1&api_key=4e8ab5f256e3c0c6e320bb8aeef18ff36c2a7c8453b26d164c0d57661488024c'
    response = HTTParty.get(url)
    content = response.parsed_response
    page_count = content["page_count"]
    jobs = Array.new
    page_count.times do |page|
      url = 'https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=Design%20and%20UX&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&api_key=4e8ab5f256e3c0c6e320bb8aeef18ff36c2a7c8453b26d164c0d57661488024c&page=' + page.to_s
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