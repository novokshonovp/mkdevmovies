
require_relative 'filerecord'
require_relative 'tmdbrecord'
require_relative 'imdbrecord'

require_relative 'moviecollection'

module MkdevMovies
  class Movie
    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    class << self
      attr_accessor :attributes
    end
    @attributes = [:period] + [FileRecord, TMDBRecord, IMDBRecord].map(&:attributes).flatten
    
    def initialize(imdb_id, collection)
      @collection = collection
      @records = [FileRecord, TMDBRecord, IMDBRecord].map do |klass|
        new_record = klass.new(imdb_id, collection.cache)
        klass.import_attributes(Movie, klass)
        [klass, new_record]
      end.to_h
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
      raise "Doesn't have field \"#{field}\"!" unless Movie.attributes.include? field
      movie_field = send(field)
      if movie_field.is_a?(Array)
        movie_field.any? { |obj| filter === obj }
      else
        filter === movie_field
      end
    end

    private

    attr_reader :collection
  end
end
