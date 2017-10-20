require './netflix'

describe Netflix do  
  let(:netflix) {  Netflix.new("movies.txt.zip","movies.txt") }

  describe "#show" do
    let(:filters) { {title: "The Terminator"} }
    subject {netflix.show(filters)} 
    context "when not enough money" do
      it { expect{ subject }.to raise_error "Not enough money!" }
    end
    context "when enough money" do
        let!(:pay){netflix.pay(100)}
        it { expect { subject }.to output(/Now showing/).to_stdout }
        it { expect{ subject }.to change(netflix, :balance).by(-3) }  
      context "when movie not exist" do
        let(:filters) { {title: "Non existant movie"} }
        it { expect{ subject }.to raise_error "No movies found!" }
      end
      context "with right params" do
        let(:filters) { {genres: "Comedy",period: "AncientMovie"}  }
        it { expect{subject}.to output(/Now showing/).to_stdout } 
      end
      context "with wrong params" do
        let(:filters) { {genre: "Comedy"}}
        it { expect{ subject }.to raise_error "Wrong filter params!" }
      end
    end
  end
  
  describe "#pay" do
    subject {netflix.pay(amount)}
    context 'when amount positive' do
      let(:amount) { 25 }
      it { expect{ subject }.to change { netflix.balance }.by(amount) }
    end
    context 'when amount negative' do
      let(:amount) { -25 }
      it { expect { subject }.to raise_error "Amount should be positive!" }
    end
  end
  
  describe "#how_much?" do
    it { expect(netflix.how_much?("The Terminator")).to be == 3 }
  end
end