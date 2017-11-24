require './lib/movie'
require './lib/moviecollection'
require './spec/test_movie'
include MkdevMovies

describe MovieCollection do
  include_context 'create_test_movie' 
  describe '#all' do
    it { expect(movie_collection.all).to all(be_a(Movie)) }
  end
  
  describe '#sort_by' do
    subject { movie_collection.sort_by(field).first }
    context 'by director' do
      let(:field) { :director }
      it { expect(subject.director).to eq('Woody Allen') }
    end
    context 'by title' do
      let(:field) { :title }
      it { expect(subject.title).to eq('12 Angry Men') } 
    end
  end
  
  describe '#filter' do
     subject { movie_collection.filter(filters).first.title }
     context 'when pass period and r_year' do
      let(:filters) { { period: 'AncientMovie', r_year: 1942 } } 
      it { is_expected.to eq 'Casablanca' }
     end
     context 'when pass director and genre' do
      let(:filters) { { :genres=>'Drama', :director=>'Sidney Lumet' } } 
      it { is_expected.to eq '12 Angry Men' }
     end
     context 'when wrong filter keys' do
      let(:filters) { {:title=>'Wrong filter key'} }
      it { expect{subject}.to raise_error 'Wrong filter options.' }
     end
  end
  describe '#stats' do
    subject { movie_collection.stats(field) }
    context 'when pass director' do
      let(:field) { :director }
      it { is_expected.to include('Stanley Kubrick' => 8) }
    end
     context 'when pass r_year' do
      let(:field) { :r_year }
      it { is_expected.to include(1995 => 10) }
    end   
  end
  
  describe '#genres' do
    subject { movie_collection.genres }
    let(:genres) { ['Crime', 'Drama', 'Action', 'Biography', 'History', 'Western', 'Adventure', 'Fantasy', 'Romance', 'Mystery', 'Sci-Fi', 'Thriller', 'Family', 'Comedy', 'War', 'Animation', 'Horror', 'Music', 'Film-Noir', 'Musical', 'Sport'] }
    it { is_expected.to match_array(genres) }
  end
  
  describe '#by_genre' do
    subject { movie_collection.by_genre.comedy.count }
    it { is_expected.to eq(39) }
  end
  
  describe '#by_country' do
    subject { movie_collection.by_country.soviet_union.count }
    it { is_expected.to eq(1) }
  end
end