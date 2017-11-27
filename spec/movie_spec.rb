require './lib/movie'
require './lib/moviecollection'
require './spec/test_movie'
include MkdevMovies

shared_examples 'create by year' do | year, movie_class_name |
  subject { Movie::create(test_movie, nil) }
  let(:test_movie){ wrong_movie[:r_year] = year 
                    wrong_movie }
  it { is_expected.to be_instance_of(movie_class_name) }
end


describe Movie do
  include_context 'create_test_movie' 
  
  describe '#matches?' do
    subject {movie.matches?(field,filter)}
    context "when matches by string" do
      let(:field){ :genres }
      let(:filter) { 'Crime' }
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

  describe "#r_date" do
    it { expect(movie.r_date).to be_instance_of(DateTime) }   
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
  
  describe ".create" do
    subject { Movie::create(movie_ostruct, nil) }
    it_behaves_like 'create by year', 1936, AncientMovie
    it_behaves_like 'create by year', 1946, ClassicMovie
    it_behaves_like 'create by year', 1970, ModernMovie
    it_behaves_like 'create by year', 2010, NewMovie
    context "when wrong period" do
      let(:movie_ostruct){ wrong_movie }
      it { expect{ subject }.to raise_error "Wrong period to create movie!"}   
    end
  end
  
end