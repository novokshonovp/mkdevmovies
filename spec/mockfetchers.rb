 require 'dotenv/load'


 shared_context 'mock_fetchers' do
  before do
    stub_request(:get, /#{imdb_data_url}/)
        .to_return(status: 200, body: response_imdb )

    stub_request(:get, /#{tmdb_data_url}/)
        .to_return(status: 200, body: response_tmdb )
  end
   let(:imdb_data_url) { ENV['IMDB_DATA_URL'] }
   let(:tmdb_data_url) { ENV['TMDB_DATA_URL'] }
   let(:tmdb_api_key) { ENV['TMDB_API_KEY'] }
   let(:response_imdb) { File.open('spec/fixtures/imdb_casablanca.html').read }
   let(:response_tmdb) { File.open('./spec/fixtures/tmdb_response').read }
end
