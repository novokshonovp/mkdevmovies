
require_relative 'filerecord'
require_relative 'tmdbrecord'
require_relative 'imdbrecord'

require_relative 'moviecollection'

module MkdevMovies
  class Movie
    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    attr_reader :attributes

    def initialize(imdb_id, collection)
      @collection = collection
      @attributes = [:period]
      @records = [FileRecord, TMDBRecord, IMDBRecord].each do |klass|
        new_record = klass.new(imdb_id, collection.cache)
        klass.import_attributes(self, new_record)
        new_record
      end
    end

    def period
      self.class.name.split('::').last
    end

    def self.create(imdb_id, collection)
      raise "No data for imdb_id: #{imdb_id}" unless collection.cache.cached?(imdb_id, :r_year)
      r_year = collection.cache.get(imdb_id, :r_year).to_i
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

    private

    attr_reader :collection
  end
end
