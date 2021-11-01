FactoryBot.define do

  factory :friendship, class: Friendship do
    member { FactoryBot.create(:member) }
    friend { FactoryBot.create(:member) }
  end

end
