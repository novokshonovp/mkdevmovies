require 'date'
require_relative 'filerecord'
require_relative 'tmdbrecord'
require_relative 'imdbrecord'

require_relative 'moviecollection'

module MkdevMovies
  class Movie
    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    ATTRS = %i[link title r_year country r_date genres runtime rating director actors period title_ru poster_id budget].freeze
    def initialize(imdb_id, collection)
      @collection = collection
      @imdb_id = imdb_id
      @fmdb = FileRecord.new(collection.cache)
      @tmdb = TMDBRecord.new(collection.cache,  { title: :title_ru, poster_path: :poster_id } )
      @imdb = IMDBRecord.new(collection.cache)
    end
 
    def link
      @fmdb.data(@imdb_id, :link)
    end

    def title
      @fmdb.data(@imdb_id, :title)
    end

    def r_year
      @fmdb.data(@imdb_id, :r_year).to_i
    end

    def country
      @fmdb.data(@imdb_id, :country)
    end

    def r_date
      Date.parse(@fmdb.data(@imdb_id, :r_date))
    end

    def genres
      @fmdb.data(@imdb_id, :genres).split(',')
    end

    def runtime
      @fmdb.data(@imdb_id, :runtime).to_i
    end

    def rating
      @fmdb.data(@imdb_id, :rating).to_f
    end

    def director
      @fmdb.data(@imdb_id, :director)
    end

    def actors
      @fmdb.data(@imdb_id, :actors).split(',')
    end
       
    def title_ru
      @tmdb.data(@imdb_id, :title_ru)
    end
    def poster_id
      @tmdb.data(@imdb_id, :poster_id)
    end
    def budget
      @imdb.data(@imdb_id, :budget)
    end
    
    def period
      self.class.name.split('::').last
    end    
    
    def self.create(imdb_id, collection)
      r_year = FileRecord.data(imdb_id, :r_year, collection.cache).to_i
      _, period =  PERIODS.detect { |key, _class| key.cover?(r_year) }
      raise 'Wrong period to create movie!' if period.nil?
      period.new(imdb_id, collection)
    end

    def has_genre?(genre)
      genres.include? genre unless collection.filter(genres: genre).count.zero?
    end

    def matches?(field, filter)
      raise "Doesn't have field \"#{field}\"!" unless attributes.include? field
      movie_field = send(field)
      if movie_field.is_a?(Array)
        movie_field.any? { |obj| filter === obj }
      else
        filter === movie_field
      end
    end
    
    def attributes
      ATTRS
    end
    private

    attr_reader :collection
  end
end
