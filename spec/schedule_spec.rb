require './lib/schedule'
include MkdevMovies
  
describe Schedule do  
  let(:dummytheatre) { Class.new { include Schedule } }
  
  context 'when create without block' do
    subject { dummytheatre.new }    
    it { expect { subject }.to  raise_error('Need a block to create Theatre!') }   
  end
  
  describe '#hall' do
      subject { 
          smelly_title = title 
          smelly_places = places
          dummytheatre.new { hall :red, title: smelly_title, places: smelly_places } } 
    context 'when right params' do
      let(:title) { 'Красный зал' }
      let(:places) { 100 }
      let(:red_hall) { { :red=>{:title=>"Красный зал", :places=>100 } } } 
      it { expect(subject.halls).to  include(red_hall) }
    end
    context 'when no title' do
      let(:title) { nil }
      let(:places) { 100 }
      it { expect { subject.halls }.to  raise_error('No title for a hall!') }   
    end
    context 'when wrong number of places' do
      let(:title) { 'Красный зал' }
      let(:places) { nil }
      it { expect { subject.halls }.to  raise_error('Places should be > 0!') }   
    end
  end
  
  describe '#period' do
    context 'when right params' do
      let(:theatre) { dummytheatre.new do
                        hall :red, title:'Красный зал', places: 100
                        hall :blue, title: 'Синий зал', places: 50 
                        period '06:00'..'12:00' do
                          description 'Утренний сеанс'
                          filters period: 'AncientMovie'
                          price 3
                          hall :red, :blue
                        end
                      end }
      let(:test_period1) { { "06:00".."12:00"=> { :description=>"Утренний сеанс", :filters=>{:period=>"AncientMovie" } , :price=>3, :hall=>[:red, :blue] } } }
      it { expect(theatre.periods).to include(test_period1) }
    end 
    context 'when periods overlaps' do
      subject { dummytheatre.new do
                        hall :red, title:'Красный зал', places: 100
                        hall :blue, title: 'Синий зал', places: 50 
                        period '06:00'..'12:00' do
                          description 'Утренний сеанс'
                          filters period: 'AncientMovie'
                          price 3
                          hall :red, :blue
                        end
                        period '11:00'..'13:00' do
                          description 'Утренний сеанс'
                          filters period: 'AncientMovie'
                          price 3
                          hall :blue
                        end                        
                      end }  
        it { expect { subject }.to raise_error 'Time range overlaps!' }                  
    end
    context 'when no scheduled halls' do
      subject { dummytheatre.new do
                        hall :red, title:'Красный зал', places: 100
                        hall :blue, title: 'Синий зал', places: 50 
                        period '11:00'..'13:00' do
                          hall :green
                        end                        
                      end }  
        it { expect { subject }.to raise_error 'Not scheduled hall!' }                  
    end   
  end
end
