json.extract! @friendship, :id
json.member do
  json.partial! 'members/member', member: @friendship.member
end
json.friend do
  json.partial! 'members/member', member: @friendship.friend
end
