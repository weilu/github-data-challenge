require 'uri'
require 'octokit'
require 'csv'

def pull_request_ids(repo, state)
  page = 0
  ids = []
  begin
    page += 1
    pulls = @client.pull_requests(repo, state, per_page: 100, page: page)
    ids += pulls.map(&:number)
  end while pulls.count == 100

  ids += pulls.map(&:number) unless page == 1 || pulls.empty?
  #puts "#{repo} #{state} pulls: #{ids.inspect}"
  #puts "#{ids.count == ids.uniq.count}"
  ids.uniq
end

@client = Octokit::Client.new(:login => "weilu", :password => ENV['_GITHUB'])

CSV.open('data/top10_watched_pulls.csv', 'wb') do |csv|
  csv << ['repo', 'closed', 'open']
  File.open 'top10_watched.csv' do |f|
    f.read.split("\n").each do |url|
      repo_path = URI.parse(url).path.slice(1..-1)
      closed = pull_request_ids(repo_path, 'closed').count
      open = pull_request_ids(repo_path, 'open').count
      puts "#{repo_path} closed: #{closed}, open: #{open}"
      csv << [repo_path, closed, open]
    end
  end
end
