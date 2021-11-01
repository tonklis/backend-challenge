FactoryBot.define do

  factory :member, class: Member do
    first_name { 'Test' }
    last_name { 'Abc' }
    url { 'http://www.google.com' }
    short_url { 'http://bitly.com' }
  end

end
