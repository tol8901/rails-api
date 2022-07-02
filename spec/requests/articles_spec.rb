require 'rails_helper'

RSpec.describe ArticlesController do
  describe '#index' do
    it 'returns a success response' do
      get '/articles'
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a proper JSON' do
      article = create :article
      get '/articles'
      # array containing only one element
      expect(json_data.length).to eq(1)
      # extract only one object with variable name expected
      expected = json_data.first
      # aggergate in one block to see all the messages that fail
      aggregate_failures do
        # compare if the returned type is as expected, and for an id
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        # check the attributes part
        expect(expected[:attributes]).to eq(
                                           title: article.title,
                                           content: article.content,
                                           slug: article.slug
                                         )
      end

    end
  end
end