require './lib/fetchercache'

include MkdevMovies

describe FetcherCache do
  context 'when FetcherCache methods' do
    let(:fetcher_cacheable) { FetcherCache.new(filename_yaml) }
    let(:imdb_id) { :tt0034583 }    
    describe '#cache?' do
      let(:field) { :title_ru }
      subject { fetcher_cacheable.cached?(imdb_id, field) }
      context 'when not cached' do
        let(:filename_yaml) { './spec/tmp/tmp_cache.yaml' }      
        it { is_expected.to be false }
      end
      context 'when cached' do
        let(:filename_yaml) { './spec/fixtures/xmdb_cache.yaml' }
         it { is_expected.to be true }     
      end
    end
    context 'put and get' do
      let(:filename_yaml) { './spec/tmp/tmp_cache.yaml' }
      let(:data) { { field_a: 'value_a' } }
      before { fetcher_cacheable.put(imdb_id, data) }
      it { expect(fetcher_cacheable.get(imdb_id, :field_a)).to eq('value_a') }
    end
  end
  context 'when extend a class behavior' do
    before do
       class DummyClass 
         include(FetcherCache::MovieExtender)
         def imdb_id
           "tt0034583"
         end
       end
    end
    let(:tmdb_data_url) { ENV['TMDB_DATA_URL'] }
    let(:tmdb_image_url) { ENV['TMDB_IMAGE_URL'] }
    let(:tmdb_api_key) { ENV['TMDB_API_KEY'] }  
    let(:fetcher_cacheable) { DummyClass.new }
      
      
    context 'when not cached' do
      before do
        fetcher_cacheable.cache_file_name(filename_yaml)
        File.delete(filename_yaml) if File.exist?(filename_yaml)    
      end
      after {  File.delete(filename_yaml) if File.exist?(filename_yaml) }
      let(:filename_yaml) { './spec/tmp/tmp_cache.yaml' }
      
      context 'when ask title_ru' do
        before { allow_any_instance_of(TMDBFetcher).to receive(:data).and_return(response) }
        let(:response) { File.open('spec/fixtures/tmdb_response').read }  
        subject { fetcher_cacheable.title_ru }
        it { is_expected.to eq("Касабланка") }      
      end
      context 'when ask budget' do
        before { allow_any_instance_of(IMDBFetcher).to receive(:data).and_return(response) }
        let(:response) { { budget: "$950,000" } }
        subject { fetcher_cacheable.budget }
        it { is_expected.to eq("$950,000") }         
      end
    end
    
    context 'when cached' do
      before { fetcher_cacheable.cache_file_name(filename_yaml) }
      let(:filename_yaml) { './spec/fixtures/xmdb_cache.yaml' }
      context 'when ask title_ru' do
        before { expect_any_instance_of(TMDBFetcher).not_to receive(:data) }
        subject { fetcher_cacheable.title_ru }
        it { is_expected.to eq("Касабланка") }
      end
      context 'when ask budget' do
        before { expect_any_instance_of(IMDBFetcher).not_to receive(:data) }
        subject { fetcher_cacheable.budget }
        it { is_expected.to eq("$950,000") }         
      end
    end
  end
end  