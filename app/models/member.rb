class Member < ApplicationRecord
  has_many :topics, dependent: :destroy

  # Friends which are directly associated to the member
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend, class_name: 'Member'

  # Friends in which the member is associated as friend
  has_many :extended_friendships, foreign_key: :friend_id, class_name: "Friendship"
  has_many :extended_friends, through: :extended_friendships, source: :member, class_name: 'Member'

  # TODO: add first_name, last_name, url validators

  # Asynch jobs with sidekiq
  after_save :shorten_url_and_get_topics

  # Search topics outside of friends and extended_friends range
  def search(topic)
    # Including and joining members
    topics = Topic.includes(member: [:friends, :extended_friends]).joins(:member)
    # filtering case insensitive topic TODO: use pgsearch for partial words
    topics = topics.where("topics.name ILIKE ?", "%#{topic}%")
    # avoiding results that are within this member's friends and extended friends range
    topics = topics.where("members.id NOT IN (?)", self.friends + self.extended_friends)

    # Find path from source member to the target member based on the topics found
    paths_per_topic = {}
    topics.each do |topic|
      visited = []
      paths = []
      # Calling the recursive find with initial values
      Member.find_path(self, self, topic.member, visited, paths)
      # Removing the head root node
      paths.map!{|path| path[1..-1]}
      unless paths.empty?
        # Getting the shortest path if more than one is found
        path = Utils.shortest_path(paths)
        # Assigning the shortest path to the topic
        paths_per_topic[topic.name] = path
      end
    end
    return paths_per_topic
  end

  # Recursive method that has a starting root node, a current traversing node
  # the target node (from topic search), the visited nodes, and the result paths
  def self.find_path(root, current, target, visited, result_paths)

    # registering the visit
    visited << current
    # A result path was found!
    if current == target
      # duplicating the array so it doesn't get modified by futher visits
      # and dropping the first position since it is the root node
      result_paths << visited.dup
      # Remove this member from the visited array
      return visited[0..-2]
    end

    # Traversing extended friends
    ext_friends = current.extended_friends
    ext_friends.each do |ext_friend|
      # only call recursively if it hasn't been visited to avoid circular loops
      unless visited.include?(ext_friend)
        # returns the visited path with this member if a path was found,
        # or the visited array without it (traversed ext friends and dint' find a path)
        visited = self.find_path(root, ext_friend, target, visited, result_paths)
      end
    end

    # Traversing direct friends
    friends = current.friends
    friends.each do |friend|
      unless visited.include?(friend)
        # returns the visited path with this member if a path was found,
        # or the visited array without it (traversed friends and dint' find a path)
        visited = self.find_path(root, friend, target, visited, result_paths)
      end
    end

    # Remove this member from the visited array
    visited = visited[0..-2]
    return visited
  end

  private

  def shorten_url_and_get_topics
    if self.short_url.nil?
      ShortenerJob.perform_later(self)
      ScraperJob.perform_later(self)
    # check if it's ok to re-calculate if save is called to update url
    elsif saved_change_to_url?
      ShortenerJob.perform_later(self)
      ScraperJob.perform_later(self)
    end
  end

end
