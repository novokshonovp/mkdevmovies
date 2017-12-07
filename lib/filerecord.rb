require 'dotenv'
require 'open-uri'

module MkdevMovies
  class FileRecord
    FILENAME_TXT = ENV['FILE_RECORD_TXT']
    DATA_STRUCTURE = %i[link title r_year country r_date genres runtime rating director actors].freeze

    def initialize(cache) 
      @cache = cache
    end

    def self.data(imdb_id, field, cache)
      return cache.get(imdb_id, field) if cache.cached?(imdb_id, field)
      cache_init(cache)
      raise "No data for imdb_id: #{imdb_id}" unless cache.cached?(imdb_id, field)
      cache.get(imdb_id, field)
    end

    def self.cache_init(cache)
      file = File.open(FILENAME_TXT).read
      CSV.parse(file, col_sep: '|', headers: DATA_STRUCTURE)
         .map do |movie_fixture|
        imdb_id = URI.parse(movie_fixture.to_hash[:link]).path.split('/').last.to_sym
        cache.put(imdb_id, movie_fixture.to_hash)
      end
      cache.save
    end
    
    def data(imdb_id, field_name)
      @cache.fetch(imdb_id, field_name)
    end
  end
end
