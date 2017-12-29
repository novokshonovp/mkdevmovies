require 'simplecov'
SimpleCov.start
require './lib/imdbfetcher'
require 'webmock/rspec'
require './spec/mockfetchers'
require 'dotenv/load'
Dotenv.overload('./spec/movies.env')

include MkdevMovies

describe IMDBFetcher do  
  include_context 'mock_fetchers' 
  let(:imdbfetcher) { IMDBFetcher.new }
     
  describe '#data' do
    subject { imdbfetcher.data(imdb_id) }
    let(:imdb_id) { "tt0034583" }
    it { is_expected.to eq( { budget: "$950,000" } ) }
  end
end