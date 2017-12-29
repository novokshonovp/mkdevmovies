require 'simplecov'
SimpleCov.start

require 'dotenv/load'
require './lib/movie'
require './lib/moviecollection'

include MkdevMovies

describe MovieCollection do
  before { Dotenv.overload('./spec/movies.env') }
  let(:movie_collection) { MovieCollection.new }
  describe '#all' do
    it { expect(movie_collection.all).to all(be_a(Movie)) }
  end

  describe '#sort_by' do
    subject { movie_collection.sort_by(field).first }
    context 'by director' do
      let(:field) { :director }
      it { expect(subject.director).to eq('James Cameron') }
    end
    context 'by title' do
      let(:field) { :title }
      it { expect(subject.title).to eq('Casablanca') }
    end
  end

  describe '#filter' do
    subject { movie_collection.filter(filters).first.title }
    context 'when pass period and r_year' do
      let(:filters) { { period: 'AncientMovie', r_year: 1942 } }
      it { is_expected.to eq 'Casablanca' }
    end
    context 'when pass director and genre' do
      let(:filters) { { genres: 'Action', director: 'James Cameron' } }
      it { is_expected.to eq 'The Terminator' }
    end
    context 'when exclude' do
      let(:filters) { { genres: 'Drama', exclude_title: 'Interstellar' } }
      it { expect(subject).to eq 'Casablanca' }
    end
    context 'when wrong filter keys' do
      let(:filters) { { title: 'Wrong filter key' } }
      it { expect { subject }.to raise_error 'Wrong filter options.' }
    end
  end
  describe '#stats' do
    subject { movie_collection.stats(field) }
    context 'when pass director' do
      let(:field) { :director }
      it { is_expected.to include('James Cameron' => 1) }
    end
    context 'when pass r_year' do
      let(:field) { :r_year }
      it { is_expected.to include(1942 => 1) }
    end
  end
  describe '#each' do
    subject { movie_collection.select { |movie| movie.title == 'Casablanca' }.first.title }
    it { is_expected.to eq 'Casablanca' }
  end

  describe '#genres' do
    subject { movie_collection.genres }
    let(:genres) { ['Action', 'Adventure', 'Drama', 'Horror', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War'] }
    it { is_expected.to match_array(genres) }
  end

  describe '#by_genre' do
    subject { movie_collection.by_genre.action.count }
    it { is_expected.to eq(1) }
  end

  describe '#by_country' do
    subject { movie_collection.by_country.usa.count }
    it { is_expected.to eq(3) }
  end
end
