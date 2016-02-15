require 'rails_helper'

describe 'Categories routing' do
  it { expect(get:    '/coding').to            route_to(controller: 'categories', action: 'coding') }
  it { expect(get:    '/music').to             route_to(controller: 'categories', action: 'music') }
  it { expect(get:    '/other').to             route_to(controller: 'categories', action: 'other') }
  it { expect(get:    '/categories').to        route_to(controller: 'categories', action: 'index') }
  it { expect(get:    '/categories/new').to    route_to(controller: 'categories', action: 'new') }
  it { expect(get:    '/categories/1/edit').to route_to(controller: 'categories', action: 'edit',    id: '1') }
  it { expect(post:   '/categories').to        route_to(controller: 'categories', action: 'create') }
  it { expect(get:    '/categories/1').to      route_to(controller: 'categories', action: 'show',    id: '1') }
  it { expect(put:    '/categories/1').to      route_to(controller: 'categories', action: 'update',  id: '1') }
  it { expect(patch:  '/categories/1').to      route_to(controller: 'categories', action: 'update',  id: '1') }
  it { expect(delete: '/categories/1').to      route_to(controller: 'categories', action: 'destroy', id: '1') }
end
