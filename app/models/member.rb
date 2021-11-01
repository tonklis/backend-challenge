class Member < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :friendships
  has_many :extended_friendships, foreign_key: "friend_id", class_name: "Friendship"

  after_save :shorten_url_and_get_topics

  # TODO: add first_name, last_name, url validators

  private

  # TODO: do these in a delayed job
  def shorten_url_and_get_topics
    if self.short_url.nil?
      self.short_url = UrlShortener.shorten_url(self.url)
      create_topics()
    # TODO: Define what to do if save is called to update url
    elsif saved_change_to_url?
      self.short_url = UrlShortener.shorten_url(self.url)
      create_topics()
    end
  end

  def create_topics
    #Deleting previous topics on update, check if it's ok
    self.topics.destroy_all

    html_headers = HeaderScraper.get_headers(self.url)
    html_headers.each do |header|
      self.topics << Topic.create!(name: header, member: self)
    end
  end
end
