require 'date'
require 'virtus'
require_relative 'moviecollection'

module MkdevMovies
  class StrArray < Virtus::Attribute
    def coerce(value)
      value.split(',')
    end
  end
  class RunTime < Virtus::Attribute
    def coerce(value)
      value.to_i
    end
  end
  class Movie
    include Virtus.model

    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    attribute :link, String
    attribute :title, String
    attribute :r_year, Integer
    attribute :country, String
    attribute :r_date, DateTime
    attribute :genres, StrArray
    attribute :runtime, RunTime
    attribute :rating, Float
    attribute :director, String
    attribute :actors, StrArray
    attribute :period, String
    
    def imdb_id
      URI.parse(link).path.split('/').last
    end

    def self.attributes
     attribute_set.each.map(&:name).push(@dynamic_attributes)
    end

    def initialize(movie, movie_collection)
      @movies_collection = movie_collection
      @dynamic_attributes = [:imdb_id]
      super(movie)
    end

    def self.create(movie, movie_collection)
      _, period =  PERIODS.detect { |key, _class| key.cover?(movie[:r_year].to_i) }
      raise 'Wrong period to create movie!' if period.nil?
      movie[:period] = period.to_s.split('::').last
      period.new(movie, movie_collection)
    end

    def to_s
      "\"#{@title}\", #{@rating}, #{@director}, #{@r_year}, #{@r_date}, #{@runtime}, #{@country}, " \
      "genres: #{@genres.join(', ')}, stars: #{@actors.join(', ')}"
    end

    def has_genre?(genre) # rubocop:disable Naming/PredicateName
      @genres.include? genre unless @movies_collection.filter(genres: genre).count.zero?
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
  end
end
