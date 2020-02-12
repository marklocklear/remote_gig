require 'kimurai'

class SimpleSpider < Kimurai::Base
  @name = "simple_spider"
  @engine = :selenium_chrome
  @start_urls = ["https://www.railroad19.com/#careers"]

  def parse(response, url:, data: {})
    jobs = Array.new
    doc = browser.current_response
    returned_jobs = doc.css('.careers-jobs-list-styles__jobsList--3_v12')
    returned_jobs.css('li').each do |char_element|
      title = char_element.css('a')[0]['aria-label']
      link = "https://apply.workable.com" + char_element.css('a')[0]['href']

      #click on job link and get description
      browser.visit(link)
      job_page = browser.current_response
      description = job_page.xpath('/html/body/div[1]/div/div[1]/div[2]/div[2]/div[2]').text
      company = 'TaxJar'
      jobs << [title, link, description, company]
    end
    return jobs
  end
end

# SimpleSpider.crawl!
blah = SimpleSpider.parse!(:parse, url: "https://apply.workable.com/taxjar/")



puts blah.inspect