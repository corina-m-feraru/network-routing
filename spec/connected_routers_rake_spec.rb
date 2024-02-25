require 'rails_helper'
require 'rake'

RSpec.describe 'connected_routers:get' do
  before(:all) do
    Rails.application.load_tasks
    Rake::Task.define_task(:environment)
  end

  describe 'connected_routers:get' do
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
      let!(:router_link4) { FactoryBot.create(:router_link, router: router3, linked_router: router2) }

      it 'calls ConnectedRouters service and outputs the connections line by line in a string format' do
        expect(ConnectedRouters).to receive(:call).and_return(['Birmingham <-> Ipswich', 'London <-> Birmingham'])
        expect { Rake::Task['connected_routers:get'].invoke }.to output("Birmingham <-> Ipswich\nLondon <-> Birmingham\n").to_stdout
      end
    end
  end
end
