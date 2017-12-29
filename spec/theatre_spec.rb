require 'simplecov'
SimpleCov.start

require 'dotenv/load'
require './lib/theatre'

include MkdevMovies

shared_examples "deposit to cashbox" do | amount|
  it { expect{ subject }.to change { theatre.cash.amount }.by(amount) }
end

describe Theatre do  
  before { Dotenv.overload('./spec/movies.env') }
  let(:theatre) { Theatre.new do
                      hall :red, title:'Красный зал', places: 100
                      hall :blue, title: 'Синий зал', places: 50
                      hall :green, title: 'Зелёный зал (deluxe)', places: 12   
                      period '06:00'..'12:00' do
                        description 'Утренний сеанс'
                        filters period: 'AncientMovie'
                        price 3
                        hall :red, :blue
                      end
                     period '12:00'..'18:00' do
                        description 'Комедии и приключения'
                        filters genres: ['Comedy', 'Adventure']
                        price 5
                        hall :green
                     end 
                     period '18:00'..'24:00' do
                        description 'Ужасы'
                        filters genres: 'Horror'
                        price 10
                        hall :green
                     end 
                  end }                   

  describe "#show" do
      subject { theatre.show(time) }
      context "when open" do 
        context "when in the morning" do
          let(:time) { "10:30" } 
          it { expect{subject}.to output("<<Now showing Casablanca 10:30 - 12:12>>\n").to_stdout  } 
        end
        context "when in the afternoon" do
          let(:time) { "13:30" }
          it  { expect{subject}.to output("<<Now showing Interstellar 13:30 - 16:19>>\n").to_stdout }
        end
        context "when at night" do
          let(:time) { "21:30" } 
          it { expect{subject}.to output("<<Now showing Psycho 21:30 - 23:19>>\n").to_stdout }
        end
      end
      context "when closed" do
        let(:time) { "00:01" } 
        it { expect{ subject }.to raise_error "Cinema closed!"  }
      end   
  end
  
  describe "#when?" do
    subject {theatre.when?(title)}
    context "when no schedule" do
      let(:title) {"The Terminator"} 
      it { expect{subject}.to raise_error "No schedule for #{title}!" }
    end
    context "when scheduled" do
      let(:title) {"Casablanca"} 
      it { is_expected.to include(title) }   end
  end
  
  describe "#buy_ticket" do
    subject {theatre.buy_ticket(time)}
    context "when in the morning" do 
      let(:time) { "10:05"}
      it { expect{ subject }.to output("You bought the $3.00 ticket for Casablanca.\n").to_stdout }
      it_behaves_like 'deposit to cashbox', 3
    end
    context "when in the afternoon" do
      let(:time) { "14:05"}
      it { expect{ subject }.to output("You bought the $5.00 ticket for Interstellar.\n").to_stdout }
      it_behaves_like 'deposit to cashbox', 5
    end
    context "when at night" do
      let(:time) { "22:05"}
      it { expect{ subject }.to output("You bought the $10.00 ticket for Psycho.\n").to_stdout }
      it_behaves_like 'deposit to cashbox', 10 
    end   
  end
end