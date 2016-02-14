require 'rails_helper'

describe 'Posts routing' do
  it { expect(get:    '/').to          route_to(controller: 'posts', action: 'index') }
  it { expect(get:    '/blah').to      route_to(controller: 'posts', action: 'show',    slug: 'blah') }
  it { expect(get:    '/blah/edit').to route_to(controller: 'posts', action: 'edit',    slug: 'blah') }
  it { expect(get:    '/new').to       route_to(controller: 'posts', action: 'new') }
  it { expect(post:   '/').to          route_to(controller: 'posts', action: 'create') }
  it { expect(put:    '/blah').to      route_to(controller: 'posts', action: 'update',  slug: 'blah') }
  it { expect(patch:  '/blah').to      route_to(controller: 'posts', action: 'update',  slug: 'blah') }
  it { expect(delete: '/blah').to      route_to(controller: 'posts', action: 'destroy', slug: 'blah') }
end
