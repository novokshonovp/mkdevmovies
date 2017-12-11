require 'simplecov'
SimpleCov.start

require 'dotenv'
Dotenv.load('./spec/movies.env') 
require './lib/movie'
require './lib/cache'
require './lib/moviecollection'
require './spec/mockfetchers'
require 'webmock/rspec'


include MkdevMovies

describe Movie do
  include_context 'mock_fetchers' 
  before do
    Dotenv.overload('./spec/movies.env') 
    FileUtils.rm_r(Dir['./spec/tmp/*']) 
  end
  after { FileUtils.rm_r(Dir['./spec/tmp/*']) }
  let(:dummycollection) { MovieCollection.new }   
  let(:movie) { Movie::create(imdb_id, dummycollection) }
  let(:imdb_id) { :tt0034583 }    

  describe '#link' do
    subject { movie.link }
    it { is_expected.to eq('http://imdb.com/title/tt0034583/?ref_=chttp_tt_32') }
  end
  
  describe '#title' do
    subject { movie.title }
    it { is_expected.to eq('Casablanca') }
  end 
  
  describe '#r_year' do
    subject { movie.r_year }
    it { is_expected.to eq(1942) }
  end   
  
  describe '#country' do
    subject { movie.country }
    it { is_expected.to eq('USA') }
  end   
  
  describe '#r_date' do
    subject { movie.r_date }
    it { is_expected.to eq(Date.parse('23-01-1943')) }
  end 
  
  describe '#genres' do
    subject { movie.genres }
    it { is_expected.to eq(["Drama", "Romance", "War"]) }
  end
  
  describe '#runtime' do
    subject { movie.runtime }
    it { is_expected.to eq(102) }
  end 
  
  describe '#rating' do
    subject { movie.rating }
    it { is_expected.to eq(8.6) }
  end 
  
  describe '#director' do
    subject { movie.director }
    it { is_expected.to eq('Michael Curtiz') }
  end 
 
  describe '#period' do
    subject { movie.period }
    it { is_expected.to eq('AncientMovie') }
  end 
   
  describe '#title_ru' do
    subject { movie.title_ru }
    it { is_expected.to eq('Касабланка') }
  end  

  describe '#poster_id' do
    subject { movie.poster_id }
    it { is_expected.to eq('/swLYxE9yB5icF85Ee873r6SpFEP.jpg') }
  end
  
  describe '#budget' do
    subject { movie.budget }
    it { is_expected.to eq('$950,000') }
  end    
  
  describe '#matches?' do
    subject {movie.matches?(field,filter)}
    context "when matches by string" do
      let(:field){ :genres }
      let(:filter) { 'Drama' }
      it {is_expected.to be true }
    end
    context "when matches by Regexp" do
      let(:field){ :genres }
      let(:filter) { /Adventure|Drama/ }
      it {is_expected.to be true }
    end
    context "when doesn't matches" do
      let(:field){ :genres }
      let(:filter) { "Adventure" }  
      it {is_expected.to be false } 
    end
    context "when doesn't have field" do
      let(:field){ :genre }
      let(:filter) { "Drama" }  
      it { expect { subject }.to raise_error "Doesn't have field \"#{field}\"!" } 
    end
  end
  
  describe "#has_genre?" do
    subject {movie.has_genre?(genre)}
    context "when has genre" do
      let(:genre) { "Drama" }
      it { is_expected.to be true }   
    end
    context "when don't have genre" do
      let(:genre) { "Adventure"}
      it {is_expected.to be false}
    end
    context "when wrong genre" do
      let(:genre) {"Wrong genre"}
      it {expect{ subject }.to raise_error /Wrong filter options/ }
    end
  end 
    
  describe '#create' do
    subject { Movie::create(imdb_id, dummycollection) }
    context 'when Casablanca' do
      let(:imdb_id) { :tt0034583 }
      it { is_expected.to be_instance_of(AncientMovie) }
      it { expect(subject.to_s).to eq('<<Casablanca - Ancient movie (1942).>>') }
    end 
    context 'when The Terminator' do
      let(:imdb_id) { :tt0088247 }
      it { is_expected.to be_instance_of(ModernMovie) }
      it { expect(subject.to_s).to eq('<<The Terminator - Modern movie, stars: Arnold Schwarzenegger, Linda Hamilton, Michael Biehn.>>') }
    end     
    context 'when Psycho' do
      let(:imdb_id) { :tt0054215 }
      it { is_expected.to be_instance_of(ClassicMovie) }
      it { expect(subject.to_s).to eq('<<Psycho - Classic movie, director: Alfred Hitchcock.>>') }
    end      
    context 'when InterStellar' do
      let(:imdb_id) { :tt0816692 }
      it { is_expected.to be_instance_of(NewMovie) }
      it { expect(subject.to_s).to eq('<<Interstellar - New movie, released 3 years ago.>>') }
    end     
    context "when worng imdb_id" do
      let(:imdb_id){ :tt00000 } 
      it { expect{ subject }.to raise_error "No data for imdb_id: #{imdb_id}" }   
    end    
    #context "when wrong period" do
    #  before { Dotenv.overload('./spec/wrong_movies.env') } # НЕ ПЕРЕГРУЖАЕТ ENV!!!
     # let(:imdb_id){ :tt0000001 }
    #  it { expect{ subject }.to raise_error 'Wrong period to create movie!' }   
    #end
  end
      
end