require 'rails_helper'

describe 'Posts routing' do
  it { expect(get: '/').to          route_to(controller: 'posts', action: 'index') }
  it { expect(get: '/blah').to      route_to(controller: 'posts', action: 'show', slug: 'blah') }
  it { expect(get: '/blah/edit').to route_to(controller: 'posts', action: 'edit', slug: 'blah') }
end
