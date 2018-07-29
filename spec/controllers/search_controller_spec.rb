require 'spec_helper'
require 'rails_helper'

describe SearchController do

  describe 'GET \'emails\'' do

    it 'renders the search page when no query is provided' do
      get 'emails'
      expect(response).to be_successful
    end

    if ENV['TEST_SOLR']
      it 'returns search results matching the query' do
        self.load_fixture_email
        Sunspot.commit
        get :emails, query: 'Kiggie'
        expect(response).to be_successful
        search = assigns(:search)
        search.total.should == 1
      end

      it 'returns no results when the query does not match' do
        self.load_fixture_email
        get :emails, query: 'AFDSFDFSD'
        expect(response).to be_successful
        search = assigns(:search)
        search.total.should == 0
      end
    end
  end
end
