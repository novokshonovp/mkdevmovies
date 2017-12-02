require './lib/movierenderer'
require './lib/netflix'
require './lib/fetchercache'
require 'webmock/rspec'
require 'dotenv/load'

include MkdevMovies

describe MovieRenderer do
  let(:tmdb_image_url) { ENV['TMDB_IMAGE_URL'] }
  let(:movierenderer) { MovieRenderer.new(netflix) }
  let(:netflix) { Netflix.new('./spec/test_one_movie.txt.zip', 'movies.txt') }
  
  describe '#render' do
    let(:template_file) { './spec/templates/show_collection.haml'}
    let(:output_file) {'./spec/tmp/show_collection.html'}
    after { File.delete(output_file) if File.exist?(output_file) }  
    before do
      Movie.include(FetcherCache::MovieExtender)
      movierenderer.render(template_file, output_file) 
    end
    it { expect(File.open('./spec/tmp/show_collection.html').read)
          .to eq (File.open('./spec/templates/show_collection.html').read) }
  end
  describe '#download_tmdb_posters' do
    before do
      stub_request(:get, "#{tmdb_image_url}#{poster_id}")
                  .to_return(status: 200, body: response)  
      stub_const('MovieRenderer::LOCAL_IMAGES', dir_to_images)
      movierenderer.download_tmdb_posters
    end
    after { File.delete(path_to_image_file) if File.exist?(path_to_image_file) }
    subject {  }
    let(:poster_id) { '/swLYxE9yB5icF85Ee873r6SpFEP.jpg' }
    let(:response) { '\xD1\xD1\xD1' }
    let(:dir_to_images) { './spec/tmp' }
    let(:path_to_image_file) { "#{dir_to_images}#{poster_id}" }
    it { expect(File.open(path_to_image_file).read ).to eq(response) }    
  end
end