require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:member_01){ create(:member, first_name: 'Ao') }
  it 'should check users behaving correctly' do
    short_url = member_01.short_url
    expect(Member.count).to eq 1
    expect(member_01.first_name).to eq 'Ao'
    expect(member_01.topics.count).to eq 0
    member_01.url = "https://www.coderia.mx"
    member_01.save
    # testing the bitly shortener
    expect(member_01.short_url).not_to eq short_url
    expect(member_01.short_url).to include("bit.ly")

    # testing the topic scraping created for the user
    expect(member_01.topics.count).to eq 2
  end
end
