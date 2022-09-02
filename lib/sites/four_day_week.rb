require 'httparty'

class FourDayWeek
  def get_jobs
    url = 'https://4dayweek.io/api'
    response = HTTParty.get(url)
    response = response.parsed_response
    parsed_jobs = response["jobs"]
    jobs = Array.new
    parsed_jobs.each do |j|
      if j["location_country"] == "USA" && (j["category"] == "Engineering" or j["category"] == "Data")
        title = j["title"]
        link = j["url"]
        description = j["description"]
        company = j["company_name"]
        jobs << [title, link, description, company]
      end
    end
    return jobs
  end
end