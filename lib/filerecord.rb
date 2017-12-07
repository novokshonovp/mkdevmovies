require 'dotenv'
require 'open-uri'
require_relative 'record'

module MkdevMovies
  module FileRecord
    include Record
    FILENAME_TXT = ENV['FILE_RECORD_TXT']
    DATA_STRUCTURE = %i[link title r_year country r_date genres runtime rating director actors].freeze

    Record.add_attributes(DATA_STRUCTURE)

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

    def link
      get(imdb_id, :link)
    end

    def title
      get(imdb_id, :title)
    end

    def r_year
      get(imdb_id, :r_year).to_i
    end

    def country
      get(imdb_id, :country)
    end

    def r_date
      Date.parse(get(imdb_id, :r_date))
    end

    def genres
      get(imdb_id, :genres).split(',')
    end

    def runtime
      get(imdb_id, :runtime).to_i
    end

    def rating
      get(imdb_id, :rating).to_f
    end

    def director
      get(imdb_id, :director)
    end

    def actors
      get(imdb_id, :actors).split(',')
    end
  end
end
