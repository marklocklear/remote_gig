require 'open-uri'
require 'nokogiri'
require 'kimurai'

class TaxJar < Kimurai::Base
  @name = "tax_jar"
  @engine = :selenium_chrome
  @start_urls = ["https://apply.workable.com/taxjar/"]

  def parse(response, url:, data: {})
    jobs = Array.new
    doc = browser.current_response
    puts doc.inspect
    returned_jobs = doc.css('#level-0')
    puts returned_jobs.inspect
    if returned_jobs.any?
      returned_jobs.css('#opening').each do |char_element|
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
    else
      return 0
    end
  end

  def get_jobs
    jobs = TaxJar.parse!(:parse, url: "https://apply.workable.com/taxjar/")
    return jobs
  end
end

blarg = TaxJar.new
jobs = blarg.get_jobs
puts jobs