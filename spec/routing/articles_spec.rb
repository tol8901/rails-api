require 'rails_helper'

RSpec.describe '/articles routes' do
  it 'routes to artilces#index' do
    # expect(get '/articles').to route_to(controller: 'articles', action: 'index')
    aggergate_failures do
      expect(get '/articles').to route_to('articles#index')
      expect(get '/articles?page[number]=3').to route_to('articles#index', page: { 'number': 3 })
    end
  end
end