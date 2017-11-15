require './lib/filtercinema'
require './lib/netflix'
include MkdevMovies
shared_examples 'return The Terminator' do 
  it { expect(subject.first.title).to eq('The Terminator') }
end
shared_examples 'return all movies' do
  it { expect(subject.count).to eq(250) }
end
describe 'FilterCinema' do
  let(:netflix) { Netflix.new('movies.txt.zip', 'movies.txt') }
  let(:filtercinema) { FilterCinema.new(netflix) }
  
  describe '#add_user_filter'do
    subject { filtercinema.add_user_filter(:filter_name) }
    it { expect { subject }.to change(filtercinema.user_filters, :size).by(1) }
  end
  
  describe '#by_field' do
    subject { filtercinema.by_field(netflix.all, filter) }
    context 'when filtered' do
      let(:filter) { { genres: 'Action', r_year: 1984 } }
      it_behaves_like 'return The Terminator'
    end
    context 'when not filtered' do
      let(:filter) { {} }
      it_behaves_like 'return all movies'
    end
  end
  
  describe '#by_codeblock' do
  subject { filtercinema.by_codeblock(netflix.all, &codeblock) }
    context 'when filtered' do
      let(:codeblock) { proc { |movie| movie.genres.include?('Action') && movie.r_year == 1984 } }
      it_behaves_like 'return The Terminator'
    end
    context 'when not filtered' do
      let(:codeblock) { nil }
      it_behaves_like 'return all movies'
    end
  end
  describe '#by_user' do
    subject { filtercinema.by_user(netflix.all, filter) }
    context 'when filtered' do
      before { filtercinema.add_user_filter(:old_good_movie, &codeblock)  }
      let(:filter) { { old_good_movie: 1984 } }
      let(:codeblock) { proc { |movie, year| movie.genres.include?('Action') && movie.r_year == year } }
      it_behaves_like 'return The Terminator'
    end
    context 'when not filtered' do
      let(:filter) { {} }
      it_behaves_like 'return all movies'
    end    
  end

  describe '#apply' do
    subject { filtercinema.apply(netflix.all, filters, &codeblock) }
    before do
      filtercinema.add_user_filter(:years_between, &user_filter)
      filtercinema.add_user_filter(:years_between_83_85, from: :years_between, arg: [1983,1985] )
    end
    let(:filters) { { actors: /Schwarz/, years_between_83_85: true } }
    let(:user_filter) { proc { |movie, year1, year2| movie.r_year.between?(year1, year2)} }
    let(:codeblock) { proc { |movie| movie.genres.include?('Action') } }
    it_behaves_like 'return The Terminator'
  end
end