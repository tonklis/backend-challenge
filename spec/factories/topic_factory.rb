FactoryBot.define do

  factory :topic, class: Topic do
    name { 'Test' }
    member { FactoryBot.create(:member) }
  end

end
