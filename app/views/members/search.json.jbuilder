json.array! @paths_per_topic do |topic_with_path|
  json.topic topic_with_path[0]
  json.path topic_with_path[1] do |member|
    json.extract! member, :first_name, :last_name
  end
end
