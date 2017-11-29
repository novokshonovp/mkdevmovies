require './lib/netflix'
require './lib/cinemaconverter'
require 'webmock/rspec'

include MkdevMovies

API_KEY = 'dad2ab070e32d9245be1effef55b641f'.freeze
FILENAME_YAML = './spec/spec_tmpdb_data.yaml'.freeze
POSTER_PATH = './spec/images'.freeze
MOVIES_PATH = './spec/test_one_movie.txt.zip'.freeze

describe CinemaConverter do
  before do
    response = File.new 'spec/imdb_casablanca.html'
    stub_request(:get, 'http://imdb.com/title/tt0034583/?ref_=chttp_tt_32')
                        .to_return(status: 200, body: response )
    allow(File).to receive(:open).and_call_original
  end
  let(:netflix) { Netflix.new('./spec/test_one_movie.txt.zip', 'movies.txt') }
  let(:converter) { CinemaConverter.new(netflix, FILENAME_YAML) }
  let(:yaml_content) { "---\n:poster_id: \"/swLYxE9yB5icF85Ee873r6SpFEP.jpg\"\n:title_ru: Касабланка\n:imdb_id: tt0034583\n" }
  
  describe '#collection' do
    subject { converter.collection }
    it { expect(subject.count).to eq(1) }
  end
    
  describe '#load_tmpdb_data_to_file' do
    before do
      response = File.new 'spec/one_movie_tmpdb.json'
      request = "https://api.themoviedb.org/3/find/tt0034583?api_key=#{API_KEY}&language=ru_RU&external_source=imdb_id"
      stub_request(:get, request).to_return(status: 200, body: response)
      allow(File).to receive(:new).with(FILENAME_YAML,'w')
      allow(File).to receive(:open).with(FILENAME_YAML,'a').and_yield( buffer )
      converter.load_tmdb_data_to_file(API_KEY, FILENAME_YAML)
    end
    let(:buffer) { StringIO.new() }
    it { expect(buffer.string).to eq(yaml_content) }
  end
 
  context 'when read yaml file' do
    before do
      allow(File).to receive(:open).with(FILENAME_YAML).and_return(yaml_content) 
      converter.add_tmpdb_data_to_collection(FILENAME_YAML)
    end   
    describe '#add_tmpdb_data_to_collection' do
      it { expect(converter.collection.first.title_ru).to eq("Касабланка") }
    end
    
    describe '#download_posters' do
      before do
        request = "http://image.tmdb.org/t/p/w185/#{converter.collection.first.poster_id}"
        stub_request(:get, request).to_return(status: 200, body: image)   
        allow(File).to receive(:open).with("#{POSTER_PATH}#{converter.collection.first.poster_id}",'wb')
                                     .and_yield( buffer )
        converter.download_posters(POSTER_PATH)
      end
      let(:image) { "\xD1\xD1\xD1" }
      let(:buffer) { StringIO.new() }
      it { expect(buffer.string).to eq(image) }
    end
  end

end