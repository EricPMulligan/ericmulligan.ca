require 'rails_helper'

describe 'Static pages routing' do
  it { expect(get: '/about-me').to route_to(controller: 'static_pages', action: 'about') }
end
