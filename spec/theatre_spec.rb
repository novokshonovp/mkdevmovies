require './theatre'

describe Theatre do  
  let(:theatre) {  Theatre.new("movies.txt.zip","movies.txt") }
  let(:movie) { Movie.new(OpenStruct.new({:link=>"http://imdb.com/title/tt0118799/?ref_=chttp_tt_26", 
                                              :title=>"Life Is Beautiful", :r_year=>"1997", 
                                              :country=>"Italy", :r_date=>"1999-02-12", 
                                              :genres=>"Comedy,Drama,Romance", :runtime=>"116 min", 
                                              :rating=>"8.6", :director=>"Roberto Benigni", 
                                              :actors=>"Roberto Benigni,Nicoletta Braschi,Giorgio Cantarini"}), 
                                              theatre)}
  describe "#show" do
      subject {theatre.show(time)}
      context "when open" do
        let(:time) { "10:30" } 
        it "shows in HD" do
          expect{subject}.to output(/^<<Now showing/).to_stdout && output(/>>$/).to_stdout &&
                             output(/[0-9][0-9]:[0-5][0-9] - [0-9][0-9]:[0-5][0-9]/).to_stdout
        end
        context "when in the morning" do
        before { expect(theatre).to receive(:filter).with(period: /AncientMovie/).and_return([movie]) }
          let(:time) { "10:30" } 
          it  { expect{subject}.to output(/Now showing/).to_stdout }
        end
        context "when at night" do
        before { expect(theatre).to receive(:filter).with(genres: /Drama|Horror/).and_return([movie])}
          let(:time) { "21:30" } 
          it  { expect{subject}.to output(/Now showing/).to_stdout }
        end
      end
      context "when closed" do
        subject {theatre.show(time)}
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
      let(:title) {"Laura"} 
      it { is_expected.to include(title) }   end
  end
end