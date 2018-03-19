gibbon = Gibbon::Request.new(api_key: ENV["MAILCHIMP_API_KEY"])
gibbon.timeout = 15
gibbon.throws_exceptions = true
# puts "MailChimp API key: #{gibbon.api_key}" # temporary