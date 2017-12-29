require 'simplecov'
SimpleCov.start
require 'dotenv'
Dotenv.load('./spec/movies.env')

require './lib/netflix'

include MkdevMovies

  shared_examples 'return The Terminator' do 
    it { expect(subject.first.title).to eq('The Terminator') }
  end
  shared_examples 'return all movies' do
    it { expect(subject.count).to eq(4) }
  end
  
describe FilterCinema do
  let(:netflix) { Netflix.new }
  let(:filtercinema) { FilterCinema.new(netflix) }
  
  describe '#add_user_filter' do
    subject { filtercinema.add_user_filter(:filter_name) }
    it { expect { subject }.to change(filtercinema.user_filters, :size).by(1) }
  end

  describe '#apply' do
    subject { filtercinema.apply(netflix.all, filters, &codeblock) }
    let(:filters) { {} }
    let(:codeblock) { nil }
    context 'when field filter' do
      let(:filters) { { genres: 'Action', r_year: 1984 } }
      it_behaves_like 'return The Terminator'
    end
    context 'when user filter' do
      before { filtercinema.add_user_filter(:old_good_movie, &user_filter)  } 
      let(:filters) { { old_good_movie: 1984 } }
      let(:user_filter) { Proc.new { |movie, year| movie.genres.include?('Action') && movie.r_year == year } }
      it_behaves_like 'return The Terminator'
    end
    context 'when filter on filter' do
      before do
        filtercinema.add_user_filter(:years_between, &user_filter)
        filtercinema.add_user_filter(:years_between_83_85, from: :years_between, arg: [1984,1984] )
      end
      let(:user_filter) { Proc.new { |movie, year1, year2| movie.genres.include?('Action') && movie.r_year.between?(year1, year2)} }
      let(:filters) { { years_between_83_85: true } }
      it_behaves_like 'return The Terminator'
    end
    context 'when code block filter' do
      let(:codeblock) { Proc.new { |movie| movie.genres.include?('Action') && movie.r_year == 1984 } }
      it_behaves_like 'return The Terminator'
    end
    context 'when all at once' do
      before do
        filtercinema.add_user_filter(:years_between, &user_filter)
        filtercinema.add_user_filter(:years_between_83_85, from: :years_between, arg: [1983,1985] )
      end
      let(:filters) { { actors: /Schwarz/, years_between_83_85: true } }
      let(:user_filter) { Proc.new { |movie, year1, year2| movie.r_year.between?(year1, year2)} }
      let(:codeblock) { Proc.new { |movie| movie.genres.include?('Action') } }
      it_behaves_like 'return The Terminator'      
    end
    context 'when filters undefined' do
      it_behaves_like 'return all movies'
    end
  end
end