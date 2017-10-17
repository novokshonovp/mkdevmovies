require './theatre'

describe Theatre do
    
  let(:theatre) {  Theatre.new("movies.txt.zip","movies.txt") }
 
  describe "#show" do
    subject {theatre.show(time)}
    let(:time) { "10:30" } 
    context "when not enough money" do
      it { expect{ subject }.to raise_error "Not enough money!" }
    end
    context "when enough money" do
      let!(:pay){theatre.pay(100)}
      it { is_expected.to include("Now showing") }
      it { expect{ subject }.to change   {theatre.balance} }  
    end    
  end
  
  describe "#when?" do
    subject {theatre.when?(title)}
    context "when no schedule" do
      let(:title) {"The Terminator"} 
      it { expect{subject}.to raise_error "No schedule for #{title}!" }
    end
    context "when scheduled" do
      let(:title) {"Laura"} 
      it { is_expected.to include(title) }   end
  end
end