require 'rails_helper'

describe 'Members', type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:headers) { { "Accept" => "application/json", 'Content-Type' => 'application/json' } }

  describe 'creating a member' do
    subject { post '/members', params: params.to_json, headers: headers }

    context 'with valid params' do
      let(:params) do
        {
          member: {
            first_name: 'Sandi',
            last_name: 'Metz',
            url: 'http://www.example.com'
          }
        }
      end

      it 'returns the correct status code' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'with missing params' do
      let(:params) { {} }

      it 'returns the correct status code' do
        subject
        expect(response).not_to have_http_status(:success)
      end
    end
  end

  let!(:member_01){ create(:member, first_name: 'Ao') }
  let!(:member_02){ create(:member, first_name: 'Io') }
  let!(:member_03){ create(:member, first_name: 'Eo') }
  let!(:member_04){ create(:member, first_name: 'Po') }

  #member_01's friendships
  let!(:friendship_01){ create(:friendship, member: member_01, friend: member_02) }
  let!(:friendship_02){ create(:friendship, member: member_03, friend: member_01) }
  let!(:friendship_03){ create(:friendship, member: member_04, friend: member_02) }

  #member_01's topics
  let!(:topic_01){ create(:topic, name: "Africa", member: member_01) }
  let!(:topic_02){ create(:topic, name: "Asia", member: member_01) }

  #member_04's topics
  let!(:topic_03){ create(:topic, name: "water shortage", member: member_04) }

  describe 'searching topics' do

    subject { get "/members/#{member_01.id}/search?topic=water", headers: headers }

    it 'returns the correct status code' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns a hash of topics with an ordered array of the members path' do
      subject
      expect(body).to be_an_instance_of(Array)
      expect(body[0]["topic"]).to eq "water shortage"
      expect(body[0]["path"].size).to eq 2
      expect(body[0]["path"][0]["first_name"]).to eq "Io"
      expect(body[0]["path"][1]["first_name"]).to eq "Po"
    end

  end

  describe 'when topic not found' do

    subject { get "/members/#{member_01.id}/search?topic=earth", headers: headers }

    it 'returns the correct status code' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns a hash of topics with an ordered array of the members path' do
      subject
      expect(body).to be_an_instance_of(Array)
      expect(body.size).to eq 0
    end

  end

  describe 'viewing all members' do

    subject { get '/members', headers: headers }

    it 'returns the correct status code' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns an array with the correct data' do
      subject
      expect(body).to be_an_instance_of(Array)
      #Checking correct data of friendships array
      expect(body.size).to eq 4
      expect(body[0]["first_name"]).to eq member_01.first_name
      expect(body[0]["last_name"]).to eq member_01.last_name
      expect(body[0]["short_url"]).to_not be nil
      expect(body[0]["friends_count"]).to eq 2
    end
  end

  describe 'viewing a member' do
    context 'when member exists' do
      subject { get "/members/#{member_01.id}", headers: headers }

      it 'returns the correct status code' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns an the correct show data' do
        subject
        # Checking correct data
        expect(body["first_name"]).to eq member_01.first_name
        expect(body["last_name"]).to eq member_01.last_name
        expect(body["url"]).to eq member_01.url
        expect(body["short_url"]).to_not be nil
        expect(body["topics"].size).to eq 2
        expect(body["topics"][0]["name"]).to eq topic_01.name
        expect(body["friends"].size).to eq 2
        expect(body["friends"][0]["short_url"]).to_not be nil
      end
    end

    context 'when member not found' do
      subject { get '/members/0', headers: headers }

      it 'returns the correct status code' do
        subject
        expect(response).not_to have_http_status(:success)
      end
    end
  end
end
