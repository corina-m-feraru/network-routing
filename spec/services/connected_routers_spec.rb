require 'rails_helper'

RSpec.describe ConnectedRouters, type: :service do
  describe '.call' do
    context 'when there are connected routers' do
      let!(:location1) { FactoryBot.create(:location, name: 'Ipswich') }
      let!(:location2) { FactoryBot.create(:location, name: 'Birmingham') }
      let!(:location3) { FactoryBot.create(:location, name: 'London') }
      let!(:router1) { FactoryBot.create(:router, location: location1) }
      let!(:router2) { FactoryBot.create(:router, name: 'Router 2', location: location2) }
      let!(:router3) { FactoryBot.create(:router, name: 'Router 3', location: location3) }
      let!(:router_link1) { FactoryBot.create(:router_link, router: router1, linked_router: router2) }
      let!(:router_link2) { FactoryBot.create(:router_link, router: router2, linked_router: router1) }
      let!(:router_link3) { FactoryBot.create(:router_link, router: router2, linked_router: router3) }

      it 'returns the connections in an array' do
        expect(described_class.call).to eq(['Birmingham <-> Ipswich'])
      end

      it 'returns unique bidirectional connections' do
        router_link4 = FactoryBot.create(:router_link, router: router3, linked_router: router2)
        connections = described_class.call
        expect(connections).to match_array(['Birmingham <-> Ipswich', 'London <-> Birmingham'])
      end
    end

    context 'when there are no connected routers' do
      before do
        allow(Router).to receive(:joins).with(:linked_routers).and_return([])
      end

      it 'returns an empty array' do
        expect(described_class.call).to eq([])
      end
    end
  end
end

