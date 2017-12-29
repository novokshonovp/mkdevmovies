require 'simplecov'
SimpleCov.start

require_relative '../lib/mkdevmovies'
require 'webmock/rspec'
require './spec/mockfetchers'
require 'dotenv/load'
Dotenv.overload('./spec/movies.env')

include Mkdevmovies

describe TMDBFetcher do
  include_context 'mock_fetchers'
  let(:tmdbfetcher) { TMDBFetcher.new }

  describe '#data' do
    subject { tmdbfetcher.data(imdb_id) }
    let(:imdb_id) { "tt0034583" }
    it { is_expected.to eq( response_tmdb ) }
  end
end
