require './lib/imdbfetcher'
require 'webmock/rspec'
require 'dotenv/load'

include MkdevMovies

describe IMDBFetcher do  
  let(:imdbfetcher) { IMDBFetcher.new }
  let(:imdb_data_url) { ENV['IMDB_DATA_URL'] }
       
  describe '#data' do
    before do
      stub_request(:get, "#{imdb_data_url}#{imdb_id}")
      .to_return(status: 200, body: response )
    end
    subject { imdbfetcher.data(imdb_id) }
    let(:imdb_id) { "tt0034583" }
    let(:response) { File.open('spec/imdb_casablanca.html').read }
    it { is_expected.to eq( { budget: "$950,000" } ) }
  end
end