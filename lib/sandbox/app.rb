require 'httparty'

url = 'https://4dayweek.io/api'
response = HTTParty.get(url)
response = response.parsed_response
jobs = response["jobs"]
# puts jobs["jobs"].count
blarg = Array.new
jobs.each do |j|
  # puts "***********"
  if j["location_country"] == "USA" && (j["category"] == "Engineering" or j["category"] == "Data")
  # puts j
    title = j["title"]
    link = j["url"]
    description = j["description"]
    company = j["company_name"]
    blarg << [title, link, description, company]
    # blarg << j
  end
end

puts blarg