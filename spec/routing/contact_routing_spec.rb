require 'rails_helper'

describe 'Contact routing' do
  it { expect(get: '/contact-me').to route_to(controller: 'contact', action: 'index') }
end
