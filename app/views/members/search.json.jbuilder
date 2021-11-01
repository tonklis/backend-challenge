paths_per_topic = @result_paths.map do |key, value|
  # key is the topic, value is the path to search array
  [ key, value ]
end
json.topics Hash[paths_per_topic]

