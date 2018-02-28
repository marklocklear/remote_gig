
require 'mechanize'

agent = Mechanize.new

agent.user_agent_alias = 'iPad"=>"Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'

agent.get("https://www.amazon.jobs/en/locations/virtual-locations?offset=0&result_limit=10&sort=relevant&category=software-development")

page = agent.page.body

puts page

p Mechanize::AGENT_ALIASES
