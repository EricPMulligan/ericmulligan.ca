require 'rails_helper'

describe 'Categories routing' do
  it { expect(get: '/coding').to route_to(controller: 'categories', action: 'coding') }
  it { expect(get: '/music').to  route_to(controller: 'categories', action: 'music') }
  it { expect(get: '/other').to  route_to(controller: 'categories', action: 'other') }
end
