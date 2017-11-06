require './movie'
require './moviecollection'
require './spec/test_movie'
describe Movie do
  include_context 'create_test_movie' 
  describe "#matches?" do
    subject {movie.matches?(field,filter)}
    context "when matches by string" do
      let(:field){ :genres }
      let(:filter) { "Crime" }
      it {is_expected.to be true }
    end
    context "when matches by Regexp" do
      let(:field){ :genres }
      let(:filter) { /Adventure|Drama/ }
      it {is_expected.to be true }
    end
    context "when doesn't matches" do
      let(:field){ :genres }
      let(:filter) { "Adventure" }  
      it {is_expected.to be false } 
    end
    context "when doesn't have field" do
      let(:field){ :genre }
      let(:filter) { "Drama" }  
      it { expect{ subject }.to raise_error "Doesn't have field \"#{field}\"!"} 
    end
  end

  describe "#month" do
    it {expect(movie.month).to eq("October")}   
  end
  
  describe "#has_genre?" do
    subject {movie.has_genre?(genre)}
    context "when has genre" do
      let(:genre) { "Drama" }
      it { is_expected.to be true }   
    end
    context "when don't have genre" do
      let(:genre) { "Adventure"}
      it {is_expected.to be false}
    end
  end
  
  describe "to create child instance" do
    subject { movie_collection.create(movie_ostruct) }
    context "when AncientMovie" do
      let(:movie_ostruct){ ancient_movie }
      it {expect(subject).to be_instance_of(AncientMovie)}    
      it "format output" do
        expect{puts subject}.to output("<<Casablanca - Ancient movie (1942).>>\n").to_stdout
      end
    end
    context "when ClassicMovie" do
      let(:movie_ostruct){ classic_movie }
      it {expect(subject).to be_instance_of(ClassicMovie)}    
      it "format output" do
        expect{puts subject}.to output("<<12 Angry Men - Classic movie, director: Sidney Lumet(other 2 movies in the list).>>\n").to_stdout
      end
    end    
    context "when ModernMovie" do
      let(:movie_ostruct){ modern_movie }
      it {expect(subject).to be_instance_of(ModernMovie)}
      it "format output" do
        expect{puts subject}.to output("<<The Shawshank Redemption - Modern movie, stars: Tim Robbins, Morgan Freeman, Bob Gunton.>>\n").to_stdout
      end
    end
    context "when NewMovie" do
      let(:movie_ostruct){ new_movie }
      it {expect(subject).to be_instance_of(NewMovie)}   
      it "format output" do
        expect{puts subject}.to output("<<Interstellar - New movie, released 3 years ago.>>\n").to_stdout
      end
    end
    context "when wrong period" do
      let(:movie_ostruct){ wrong_movie }
      it { expect{ subject }.to raise_error "Wrong period to create movie!"}   
    end
  end
  
end