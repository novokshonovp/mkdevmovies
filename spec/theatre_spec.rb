require './theatre'

describe Theatre do  
  let(:theatre) {  Theatre.new("./spec/test_movies.txt.zip","movies.txt") }
  let(:fake_schedule) { {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Horror"]}} } 
  describe "#show" do
      subject {theatre.show(time)}
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
          it  { stub_const("Theatre::SCHEDULE_INTERNAL", fake_schedule.transform_values{ |filter| filter.transform_values(&Regexp.method(:union)) } )
                expect{subject}.to output("<<Now showing Psycho 21:30 - 23:19>>\n").to_stdout }
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
end