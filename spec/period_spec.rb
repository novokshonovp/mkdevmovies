require 'simplecov'
SimpleCov.start

require_relative '../lib/mkdevmovies'
include Mkdevmovies

describe Period do
  let(:period) { Period.new('10:00'..'12:00') do
                   description 'Комедии и приключения'
                   filters genres: ['Comedy', 'Adventure']
                   price 5
                   hall :green
                   end }

  describe '#overlaps?' do
    subject { period.overlaps?(new_period) }
    context 'when overlaps by halls and time range' do
      let(:new_period) { Period.new('11:00'..'13:00') do
                             description 'Комедии и приключения'
                             filters genres: ['Comedy', 'Adventure']
                             price 5
                             hall :green
                           end  }
      it { is_expected.to be true }
    end
    context 'when same hall and dif time range' do
      let(:new_period) { Period.new('12:00'..'13:00') do
                             description 'Комедии и приключения'
                             filters genres: ['Comedy', 'Adventure']
                             price 5
                             hall :green
                           end  }
      it { is_expected.to be false }
    end
    context 'when dif hall and same time range' do
      let(:new_period) { Period.new('11:00'..'13:00') do
                             description 'Комедии и приключения'
                             filters genres: ['Comedy', 'Adventure']
                             price 5
                             hall :blue
                           end  }
      it { is_expected.to be false }
    end
  end

  describe '#parse_filter' do
    subject { period.parse_filter }
    context 'when has a title' do
      let(:period) { Period.new('11:00'..'13:00') do
                       description 'Комедии и приключения'
                       title 'The Terminator'
                       price 5
                       hall :blue
                     end  }
      it { is_expected.to eq( { title: "The Terminator" } ) }
    end
    context 'when have filters' do
      it { is_expected.to eq({ genres: /Comedy|Adventure/ } ) }
    end
  end
end
