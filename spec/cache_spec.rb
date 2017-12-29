require 'simplecov'
SimpleCov.start
require_relative '../lib/mkdevmovies'

include Mkdevmovies
describe Cache do
  let(:cache_file) { './spec/fixtures/xmdb_cache.yaml' }
  let(:cache) { Cache.new(cache_file)  }
  describe '#new' do
    it { expect(cache.data.keys.first).to eq(:tt0034583) }
  end

  describe '#put' do
    before { cache.put(:tt000001, cache_data) }
    let (:cache_data) { { title: 'test title' } }
    it { expect(cache.data[:tt000001]).to eq(cache_data) }
  end

  describe '#get' do
    subject { cache.get(:tt0034583,:title_ru) }
    it { is_expected.to eq("Касабланка") }
  end

  describe '#save' do
    before do
      allow(File).to receive(:open).with(cache_file,'r:bom|utf-8').and_call_original
      expect(File).to receive(:write).with(cache_file, cache.data.to_yaml)
    end
    subject { cache.save }
    it { is_expected.to eq(cache) }
  end

end
