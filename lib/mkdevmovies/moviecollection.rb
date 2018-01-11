require 'open-uri'
require 'csv'
require 'dotenv'
require_relative 'movie'
require_relative 'cache'

module Mkdevmovies
  # @author Pavel Novokshonov
  # @attr_reader [Cache] cache Cache object for IMDB and TMDB data fetchers
  class MovieCollection
    include Enumerable
    attr_reader :cache
    # Defina a csv file structure named +DATA_STRUCTURE+ and sets a constant value for it
    DATA_STRUCTURE = %i[link title r_year country r_date genres runtime rating director actors].freeze
    # Handles an initialization
    #   Create Cache object @cache.
    #   Read and parse csv data from a file to @movies Array structure.
    #   Uses +DATA_STRUCTURE+ as a parser key.
    #   Uses +FILE_CACHE_YAML+ envirinment value as a path to cache file.
    #   Uses +FILE_RECORD_TXT+ envirinment value as a path to csv data file.
    def initialize
      @cache = Cache.new(ENV['FILE_CACHE_YAML'])
      file = File.open(ENV['FILE_RECORD_TXT']).read
      @movies = CSV.parse(file, col_sep: '|', headers: DATA_STRUCTURE)
                   .map { |movie_fixture| Movie.create(movie_fixture.to_hash, self) }
    end
    # Return all records of a collection
    # @return [Array<Movie>] Collection of movies
    def all
      @movies
    end

    # Adds custom dehavior to enum sort_by to use last name of :director field
    # @param sort_key [Symbol] Movie field
    # @return (see #all)
    # @example MovieCollection.new.sort_by(:director)
    def sort_by(sort_key)
      if sort_key == :director
        @movies.sort_by { |x| x.director.split.last }
      else
        @movies.sort_by { |x| x.send(sort_key) }
      end
    end

    # Filters collection by set of keys. Extacts the 'exclude_' keyword from a movie field
    # and use it as a reverse operator.
    # @param filters [Hash] Hash of a movie fields and keys to filter
    # @return (see #all)
    # @example col = MovieCollection.new
    #   col.filter(period: 'AncientMovie', r_year: 1942) #filter by period and r_year
    #   col.filter(genres: 'Drama', exclude_title: 'Interstellar') # or with an exclude field option
    def filter(**filters)
      movies = @movies.select do |movie|
        filters.all? do |field, filter_key|
          if field.to_s.include?('exclude')
            !movie.matches?(field.to_s.split('exclude_').last.to_sym, filter_key)
          else
            movie.matches?(field, filter_key)
          end
        end
      end
      movies.empty? ? (raise 'Wrong filter options.') : movies
    end

    # Rearranges colection to get statistical data
    # @param field [Symbol] Movie field
    # @return (see #all)
    # @example col = MovieCollection.new
    #   col.stats(:director)
    def stats(field)
      @movies.flat_map { |obj| obj.send(field) }
             .compact
             .each_with_object(Hash.new(0)) { |obj, stats| stats[obj] += 1 }
    end

    # Gets all genres from a collection
    # @return [Array<String>] Array of strings containing genres
    def genres
      @movies.flat_map(&:genres).uniq
    end

    # Filters collection by genre
    # @return (see #all)
    # @example
    #   col = MovieCollection.new
    #   col.by_genre.comedy

    def by_genre
      @by_genre ||= Genres.new(self)
    end

    # Filters collection by country
    # @return (see #all)
    # @example
    #   col = MovieCollection.new
    #   col.by_country.USA
    def by_country
      @by_country ||= Countrys.new(self)
    end

    #Provides an each method to Enumerable mixin
    def each(&block)
      @movies.each(&block)
    end

    private

    class Genres
      def initialize(collection)
        collection.genres.each do |name|
          self.class.send(:define_method, name.downcase) do
            collection.filter(genres: name)
          end
        end
      end
    end

    class Countrys
      def initialize(collection)
        @collection = collection
      end

      def method_missing(country_name)
        @collection.filter(country: Regexp.new(country_name.to_s.tr('_', ' '), 'i'))
      end
    end
  end
end
