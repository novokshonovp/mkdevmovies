require 'dotenv'
require 'open-uri'
require_relative 'record'

module MkdevMovies
  class FileRecord < Record
    FILENAME_TXT = ENV['FILE_RECORD_TXT']
    
    FIELDS = { link: :to_s,
               title: :to_s,
               r_year: :to_i,
               country: :to_s,
               r_date: Date.method(:parse),
               genres: ->(v) { v.split(',') },
               runtime: :to_i,
               rating: :to_f,
               director: :to_s,
               actors: ->(v) { v.split(',') } }.freeze
               
    class << self
      attr_reader :attributes
    end
    
    @attributes = FIELDS.keys
    def get(field)
      value = super(field)
      FIELDS[field].to_proc.call(value)
    end
    
    def self.data(imdb_id, field, cache)
      return cache.get(imdb_id, field) if cache.cached?(imdb_id, field)
      cache_init(cache)
      raise "No data for imdb_id: #{imdb_id}" unless cache.cached?(imdb_id, field)
      cache.get(imdb_id, field)
    end

    def self.cache_init(cache)
      file = File.open(FILENAME_TXT).read
      CSV.parse(file, col_sep: '|', headers: FIELDS.keys)
         .map do |movie_fixture|
        imdb_id = URI.parse(movie_fixture.to_hash[:link]).path.split('/').last.to_sym
        cache.put(imdb_id, movie_fixture.to_hash)
      end
      cache.save
    end
    
  end
end
