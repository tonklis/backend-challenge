require 'rails_helper'

describe 'Friendships', type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:headers) { { "Accept" => "application/json", 'Content-Type' => 'application/json' } }

  let!(:member_01){ create(:member, first_name: 'Ao') }
  let!(:member_02){ create(:member, first_name: 'Io') }

  describe 'creating a friendship' do
    subject { post '/friendships', params: params.to_json, headers: headers }

    context 'with valid params' do
      let(:params) do
        {
          friendship: {
            member_id: member_01.id,
            friend_id: member_02.id,
          }
        }
      end

      it 'returns the correct status code' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'with empty params' do
      let(:params) { {} }

      it 'returns the correct status code' do
        subject
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          friendship: {
            member_id: 0,
            friend_id: 1,
          }
        }
      end

      it 'returns the correct status code' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end
end
