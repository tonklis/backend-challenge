require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:member_01){ create(:member, first_name: 'Ao') }
  let!(:member_02){ create(:member, first_name: 'Io') }
  let!(:member_03){ create(:member, first_name: 'Ao') }
  let!(:member_04){ create(:member, first_name: 'Io') }

  context 'search algorithm' do
    let!(:soccer) { create(:topic, name: 'Soccer in Europe', member: member_01) }
    let!(:money) { create(:topic, name: 'money in America', member: member_02) }
    let!(:cash) { create(:topic, name: 'Water in Africa', member: member_03) }
    let!(:cash) { create(:topic, name: 'Water in Australia', member: member_03) }
    let!(:cash) { create(:topic, name: 'Tech in Asia', member: member_04) }

    let!(:friendship_01) { create(:friendship, member: member_01, friend: member_02) }
    let!(:friendship_02) { create(:friendship, member: member_03, friend: member_02) }
    let!(:friendship_03) { create(:friendship, member: member_04, friend: member_03) }

    it 'should return a path from member_01 to member_04' do
      result = member_01.search("asia")
      expect(result.size).to eq 1
      expect(result["Tech in Asia"].size).to eq 3
      expect(result["Tech in Asia"][2].id).to be member_04.id
      expect(result["Tech in Asia"][1].id).to be member_03.id
      expect(result["Tech in Asia"][0].id).to be member_02.id
    end

  end

  context 'member model creation and associations check' do
    it 'should check users behaving correctly' do
      short_url = member_01.short_url
      expect(Member.count).to eq 4
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

end
