require './netflix'
require 'money'

describe Netflix do  
  let(:netflix) {  Netflix.new("movies.txt.zip","movies.txt") }

  describe "#show" do
    let(:filters) { {title: "The Terminator"} }
    subject {netflix.show(filters)} 
    context "when not enough money" do
      it { expect{ subject }.to raise_error "Not enough money!" }
    end
    context "when enough money" do
        before { netflix.pay(100) 
                 @time_now = Time.now
                 allow(Time).to receive(:now).and_return(@time_now) }
        let(:terminator_runtime) { 107 }
        let(:film_price) { Money.from_amount(3, :USD) }
        let(:show_output) { "<<Now showing The Terminator #{@time_now.strftime("%H:%M")} - #{(@time_now + terminator_runtime*60).strftime("%H:%M")}>>\n"}
        it { expect { subject }.to output(show_output).to_stdout }
        it { expect{ subject }.to change(netflix, :user_balance).by(-film_price) }  
      context "when movie not exist" do
        let(:filters) { {title: "Non existant movie"} }
        it { expect{ subject }.to raise_error "Wrong filter options. No movie in the database!" }
      end
      context "with wrong params" do
        let(:filters) { {genre: "Comedy"}}
        it { expect{ subject }.to raise_error "Doesn't have field \"#{filters.keys.first}\"!" }
      end
    end
  end
  
  describe "#pay" do
    context 'when amount positive' do
      subject {netflix.pay(amount.amount)}
      let(:amount) { Money.from_amount(25, :USD) }
      it { expect{ subject }.to change(netflix, :user_balance).by(amount) }
      it { expect{ subject }.to change(Netflix, :cash).by(amount) }
    end
    context 'when amount negative' do
      subject {netflix.pay(amount)}
      let(:amount) { -25 }
      it { expect { subject }.to raise_error "Amount should be positive!" }
    end
  end
  
  describe "#how_much?" do
    let(:film_price) { Money.from_amount(3, :USD) }
    it { expect(netflix.how_much?("The Terminator")).to eq film_price }
  end
end