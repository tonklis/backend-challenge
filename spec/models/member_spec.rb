require 'rails_helper'

RSpec.describe Member, type: :model do
  let!(:member_01){ create(:member, first_name: 'Ao') }
  it 'should check users behaving correctly' do
    expect(Member.count).to eq 1
    expect(member_01.first_name).to eq 'Ao'
  end
end
