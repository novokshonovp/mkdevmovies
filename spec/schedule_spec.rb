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
      it { expect(subject.halls).to  include( { :red=>{:title=>"Красный зал", :places=>100 } } ) }
    end
    context 'when wrong number of places' do
      let(:title) { 'Красный зал' }
      let(:places) { 0 }
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
      let(:test_time_range) { "06:00".."12:00" }
      let(:test_params) { { :description=>"Утренний сеанс", :filters=>{:period=>"AncientMovie" } , :price=>3, :hall=>[:red, :blue] } }
      it { expect(theatre.schedule.first.time_range).to include(test_time_range) }
      it { expect(theatre.schedule.first.params).to include(test_params ) }
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
        it { expect { subject }.to raise_error 'Undefined halls: [:green]!' }                  
    end   
  end
  describe '#halls_by_periods' do
      subject { theatre.halls_by_periods }
      let(:theatre) { dummytheatre.new do
                        hall :red, title:'Красный зал', places: 100
                        period '06:00'..'12:00' do
                          hall :red
                        end
                      end }
      it { is_expected.to eq( { red: ["06:00".."12:00"] } ) }
  end
end
