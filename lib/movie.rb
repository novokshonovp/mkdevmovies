require_relative 'tmdbrecord'
require_relative 'imdbrecord'
require_relative 'moviecollection'
require 'dry-initializer'

module MkdevMovies
  class Movie 
    extend Dry::Initializer
    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    EXTENDERS = [TMDBRecord, IMDBRecord]
    EXTENDERS.each{ |klass| klass.import_attributes(Movie)}
    
    option :link, type: proc(&:to_s)
    option :title, type: proc(&:to_s)
    option :r_year, type: proc(&:to_i)
    option :country, type: proc(&:to_s)
    option :r_date, type: Date.method(:parse)
    option :genres, type: ->(v) { v.split(',') }
    option :runtime, type: proc(&:to_i)
    option :rating, type: proc(&:to_f)
    option :director, type: proc(&:to_s)
    option :actors, type: ->(v) { v.split(',') }

    def self.attributes
      [:period] + Movie.dry_initializer.attributes(self).keys + EXTENDERS.map(&:attributes).flatten
    end
    
    def initialize(movie, collection)
      @collection = collection
      imdb_id = URI.parse(movie[:link]).path.split('/').last.to_sym
      @records = EXTENDERS.map do |klass|
        new_record = klass.new(imdb_id, collection.cache)
        [klass, new_record]
      end.to_h
     super(movie)
    end

    def period
      self.class.name.split('::').last
    end

    def self.create(movie, collection)
      _, period =  PERIODS.detect { |key, _class| key.cover?(movie[:r_year].to_i) }
      raise 'Wrong period to create movie!' if period.nil?
      period.new(movie, collection)
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
