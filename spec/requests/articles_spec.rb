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

    it 'returns articles in the proper order' do
      # Create a new article which want to be the recent one
      recent_article = create(:article)
      # Create an older article, created 1 hour ago
      older_article = create(:article, created_at: 1.hour.ago)
      # Call a request
      get '/articles'
      # Verify if it returns records in the correct order
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to(
        eq([recent_article.id, older_article.id])
      )
    end

    it 'pagenates results' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq([article2.id])
    end

    it 'contains pagination links in the response' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json['links'].length).to eq(5)
      expect(json['links'].keys).to contain_exactly(
        'first', 'prev', 'next', 'last', 'self'
      )

    end
  end
end