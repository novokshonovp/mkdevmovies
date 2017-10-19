require './theatre'

describe Theatre do
    
  let(:theatre) {  Theatre.new("movies.txt.zip","movies.txt") }
 
  describe "#show" do
      context "when open" do
        arguments = {morning: "9:30", afternoon: "12:45", night: "21:00"}
        stdout = StringIO.new
        $stdout = stdout
        arguments.each{|day_time,time|
                      it "should show a movie  in the #{day_time}" do
                        theatre.show(time)
                        expect($stdout.string.split("\n").count{|movie| 
                                movie.include?($stdout.string.split("\n").last[0..-16]) }).to eq(1)
                      end
                      }
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