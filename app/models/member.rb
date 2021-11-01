class Member < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :friendships
  has_many :extended_friendships, foreign_key: "friend_id", class_name: "Friendship"

  after_save :shorten_url_and_get_topics

  # TODO: add first_name, last_name, url validators

  # Search algorithm first approach
  def search(topic)
    #1. Search topics outside's friends and extended_friends

    # Including and joining members
    topics = Topic.includes(:member).joins(:member)
    # filtering case insensitive topic TODO: use pgsearch for partial words
    topics = topics.where("topics.name ILIKE ?", "%#{topic}%")
    # avoiding results that are within this member's friends
    topics = topics.where("members.id NOT IN (?)", self.friendships + self.extended_friendships)

    #2. Find path from source member to each topic's member
    result_paths = {}
    topics.each do |topic|
      visited = []
      path = []
      Member.find_path(self, self, topic.member, path, visited)
      result_paths[topic.name] = path if !path.empty? && path.reverse!
    end
    return result_paths

  end

  # Recursive method that has a starting root node, a current traversing node
  # the target node (got from topic search), the result path and the visited nodes
  # TODO: fix to get the shortest path - it only returns the first found path
  def self.find_path(root, current, target, paths, visited)

    path_size = paths.size
    visited << current
    # There is a path
    if current == target
      paths << current
      return
    end

    ext_friends = current.extended_friendships
    ext_friends.each do |ext_friend|
      self.find_path(root, ext_friend.member, target, paths, visited) if !visited.include?(ext_friend.member)
    end

    friends = current.friendships
    friends.each do |friend|
      self.find_path(root, friend.friend, target, paths, visited) if !visited.include?(friend.friend)
    end

    if path_size != paths.size
      paths << current if current != root
    end

  end

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
