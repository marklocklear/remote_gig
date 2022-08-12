require 'httparty'

url = "https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=Design%20and%20UX&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&page=1&api_key=" + ENV['THE_MUSE']
response = HTTParty.get(url)
content = response.parsed_response
page_count = content["page_count"]
blarg = Array.new
  # puts "page count: " + jobs["page_count"].inspect
page_count.times do |page|
  url = 'https://www.themuse.com/api/public/jobs?category=Computer%20and%20IT&category=Data%20Science&category=Design%20and%20UX&category=IT&category=Software%20Engineer&location=Flexible%20%2F%20Remote&page=' + page.to_s + '&' + ENV['THE_MUSE']
  response = HTTParty.get(url)
  jobs = response.parsed_response
  jobs["results"].each do |j|
      title = j["name"]
      link = j["refs"]["landing_page"]
      description = j["contents"]
      company = j["company"]["name"]
      blarg << [title, company, description, link]
  end
end

  puts blarg