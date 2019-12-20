require 'open-uri'
require 'nokogiri'
require 'json'

desc 'pull changelog for RemoteGig from GitHub'
task changelog: :environment do
  spinner = TTY::Spinner.new('[:spinner] :title')
  spinner.update(title: 'Getting changelog...')
  spinner.auto_spin

  file = File.open("#{Rails.root}/public/changelog.txt", 'w')
  file.puts "#{Time.now}: Begin get changelog."

  # get latest commits from GitHub and turn json into a hash
  url = "https://api.github.com/repos/marklocklear/remote_gig/commits?since=#{1.month.ago}"
  commits_json = Nokogiri::HTML(open(url)).css('p').text
  commits_hashes = JSON.parse(commits_json)

  file.puts "#{commits_hashes.count} commits since #{1.month.ago}:\n"

  commits_hashes.each do |commit|
    commit = ActiveSupport::HashWithIndifferentAccess.new(commit) # allows #dig()
    date = commit.dig(:commit, :author, :date)
    message = commit.dig(:commit, :message).gsub(/\n\n/, ': ')
    file.puts date + ' ' + message
  end

  spinner.stop('All done!')
  file.close
end
