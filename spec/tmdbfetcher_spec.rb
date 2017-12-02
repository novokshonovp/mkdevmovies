require './lib/tmdbfetcher'
require 'webmock/rspec'
require 'dotenv/load'

include MkdevMovies

describe TMDBFetcher do  
  let(:tmdbfetcher) { TMDBFetcher.new }
  let(:tmdb_data_url) { ENV['TMDB_DATA_URL'] }
  let(:tmdb_api_key) { ENV['TMDB_API_KEY'] }
       
  describe '#data' do
    before do
      stub_request(:get, "#{tmdb_data_url}#{imdb_id}?api_key=#{tmdb_api_key}&language=ru_RU&external_source=imdb_id")
      .to_return(status: 200, body: response )
    end
    subject { tmdbfetcher.data(imdb_id) }
    let(:imdb_id) { "tt0034583" }
    let(:response) { File.open('./spec/fixtures/tmdb_response').read }
    it { is_expected.to eq( response ) }
  end
end