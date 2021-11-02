require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:member_01){ create(:member, first_name: 'Ao') }

  context 'search algorithm' do

    let!(:member_02){ create(:member, first_name: 'Bo') }
    let!(:member_03){ create(:member, first_name: 'Co') }
    let!(:member_04){ create(:member, first_name: 'Do') }
    let!(:member_05){ create(:member, first_name: 'Eo') }
    let!(:member_06){ create(:member, first_name: 'Fo') }

    let!(:soccer) { create(:topic, name: 'Soccer in Europe', member: member_01) }
    let!(:money) { create(:topic, name: 'money in America', member: member_02) }
    let!(:water) { create(:topic, name: 'Water in Africa', member: member_03) }
    let!(:tech) { create(:topic, name: 'Tech in Asia', member: member_04) }
    let!(:music) { create(:topic, name: 'Music in Australia', member: member_05) }
    let!(:vaping) { create(:topic, name: 'Vaping in Africa', member: member_06) }

    describe 'search a topic that is part of the friends and extended friends' do

      let!(:friendship_01) { create(:friendship, member: member_01, friend: member_02) }
      let!(:friendship_02) { create(:friendship, member: member_03, friend: member_02) }
      let!(:friendship_03) { create(:friendship, member: member_06, friend: member_01) }

      it 'should not return any results' do
        result = member_01.search("money")
        expect(result.size).to eq 0
        result = member_01.search("vaping")
        expect(result.size).to eq 0
      end

      it 'should only return the result from the non connected friends' do
        result = member_01.search("africa")
        expect(result.size).to eq 1
        expect(result["Water in Africa"].size).to eq 2
        expect(result["Water in Africa"][1].id).to be member_03.id
        expect(result["Water in Africa"][0].id).to be member_02.id
      end

    end

    describe 'search that matched two or more topics' do

      let!(:friendship_01) { create(:friendship, member: member_01, friend: member_02) }
      let!(:friendship_02) { create(:friendship, member: member_03, friend: member_02) }
      let!(:friendship_03) { create(:friendship, member: member_02, friend: member_06) }

      it 'should return two topics with results' do
        result = member_01.search("africa")
        expect(result.size).to eq 2
        expect(result["Water in Africa"].size).to eq 2
        expect(result["Vaping in Africa"].size).to eq 2
      end

    end

    describe 'search with one result path' do

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

    describe 'search with two or more result paths' do

      let!(:friendship_01) { create(:friendship, member: member_01, friend: member_02) }
      let!(:friendship_02) { create(:friendship, member: member_03, friend: member_02) }
      let!(:friendship_03) { create(:friendship, member: member_04, friend: member_03) }
      let!(:friendship_04) { create(:friendship, member: member_05, friend: member_03) }
      let!(:friendship_05) { create(:friendship, member: member_04, friend: member_05) }
      let!(:friendship_06) { create(:friendship, member: member_06, friend: member_05) }
      let!(:friendship_07) { create(:friendship, member: member_06, friend: member_01) }

      it 'should return the shortest path from member_01 to member_05' do
        result = member_01.search("music")
        expect(result.size).to eq 1
        expect(result["Music in Australia"].size).to eq 2
        expect(result["Music in Australia"][1].id).to be member_05.id
        expect(result["Music in Australia"][0].id).to be member_06.id
      end

    end

  end

  context 'member model creation and associations check' do
    it 'should check users behaving correctly' do
      short_url = member_01.short_url
      expect(Member.count).to eq 1
      expect(member_01.first_name).to eq 'Ao'
      expect(member_01.topics.count).to eq 0
      member_01.url = "https://www.coderia.mx"
      member_01.save
      # testing the bitly shortener
      # TODO: Test url shortener in delayed job
      # expect(member_01.short_url).not_to eq short_url
      # expect(member_01.short_url).to include("bit.ly")

      # testing the topic scraping created for the user
      # expect(member_01.topics.count).to eq 2
    end
  end

end
