class ScraperJob < ApplicationJob
  queue_as :default

  def perform(member)
    member.topics.destroy_all

    html_headers = HeaderScraper.get_headers(member.url)
    html_headers.each do |header|
      member.topics << Topic.create!(name: header, member: member)
    end
  end
end
