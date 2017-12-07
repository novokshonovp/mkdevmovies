require 'simplecov'
SimpleCov.start

require 'dotenv/load'
require './lib/netflix'
require 'money'

include MkdevMovies

shared_examples 'show The Terminator' do 
  before do
    allow(Time).to receive(:now).and_return(time_now)
  end
  let(:terminator_runtime) { 107 }  
  let(:time_now) { Time.now }
  it {expect { subject}.to output("<<Now showing The Terminator #{ time_now.strftime("%H:%M") } - #{ (time_now + terminator_runtime * 60).strftime("%H:%M") }>>\n").to_stdout }
end

describe Netflix do
  before {    Dotenv.overload('./spec/movies.env') }  
  let(:netflix) {  Netflix.new }

  describe '#show' do
    let(:filters) { {title: 'The Terminator'} }
    subject { netflix.show(filters) } 
    context 'when not enough money' do
      it { expect { subject } .to raise_error 'Not enough money!' }
    end
    context 'when enough money' do
        before { netflix.pay(100) }
        let(:film_price) { Money.from_amount(3, :USD) }
        it_behaves_like 'show The Terminator'
        it { expect{ subject }.to change(netflix, :user_balance).by(-film_price) }  
      context 'when movie not exist' do
        let(:filters) { { title: 'Non existant movie' } }
        it { expect { subject }.to raise_error 'Wrong filter options.' }
      end
      context 'with wrong params' do
        let(:filters) { { genre: 'Comedy' } }
        it { expect { subject }.to raise_error "Doesn't have field \"#{ filters.keys.first }\"!" }
      end
      context 'when filter by code block' do    
        subject { netflix.show(filters, &block_filter) }
        context 'when return result' do
          let(:block_filter) { ->(movie){  movie.genres.include?('Action') && movie.r_year == 1984 } }
          let(:filters) { {} }
          it_behaves_like 'show The Terminator'
        end
        context 'when nothing to return' do
          let(:block_filter) { ->(movie){  !movie.title.include?('The Terminator') } }
          let(:filters) { {title: 'The Terminator'} }
          it { expect { subject }.to raise_error "Nothing to show. Change a block's filter options." }
        end
      end
    end
  end
  
  describe '#pay' do
    context 'when amount positive' do
      subject { netflix.pay(amount.amount) }
      let(:amount) { Money.from_amount(25, :USD) }
      it { expect { subject }.to change(netflix, :user_balance).by(amount) }
      it { expect { subject }.to change(Netflix, :cash).by(amount) }
    end
    context 'when amount negative' do
      subject { netflix.pay(amount) }
      let(:amount) { -25 }
      it { expect { subject }.to raise_error 'Amount should be positive!' }
    end
  end
  
  describe '#how_much?' do
    let(:film_price) { Money.from_amount(3, :USD) }
    it { expect(netflix.how_much?('The Terminator')).to eq film_price }
  end
  describe '#define_filter' do
    subject { netflix.define_filter(filter) }
    context 'when define' do
      let (:filter) { ->(movie){  movie.period == 'ModernMovie' && !movie.country.include?('UK') } }      
      it { expect { subject }.to change(netflix.key_filter.user_filters, :size).by(1) }
    end
  end
end