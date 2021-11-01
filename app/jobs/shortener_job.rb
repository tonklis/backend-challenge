class ShortenerJob < ApplicationJob
  queue_as :default

  def perform(member)
    short_url = UrlShortener.shorten_url(member.url)
    member.update_attributes(short_url: short_url)
  end

end
