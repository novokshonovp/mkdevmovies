require 'date'
module MkdevMovies

  class Movie
    require_relative 'movie_children'
    PERIODS = { 1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie,
                2001..Date.today.year => NewMovie }.freeze
    ATTRIBUTES = %i[link title r_year country r_date genres
                    runtime rating director actors period].freeze
    attr_reader(*ATTRIBUTES)

    def initialize(movie, movie_collection) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      @movies_collection = movie_collection
      @link = movie.link
      @title = movie.title
      @r_year = movie.r_year.to_i
      @country = movie.country
      @r_date = movie.r_date
      @genres = movie.genres.split(',')
      @runtime = movie.runtime.to_i
      @rating = movie.rating
      @director = movie.director
      @actors = movie.actors.split(',')
    end

    def self.create(movie, movie_collection)
      raise 'Wrong period to create movie!' if PERIODS.detect do |period, _movie_class|
                                                 period.cover?(movie.r_year.to_i)
                                               end.nil?
      PERIODS.detect do |period, _movie_class|
        period.cover?(movie.r_year.to_i)
      end.last.new(movie, movie_collection)
    end

    def to_s
      "\"#{@title}\", #{@rating}, #{@director}, #{@r_year}, #{@r_date}, #{@runtime}, #{@country}, " \
      "genres: #{@genres.join(', ')}, stars: #{@actors.join(', ')}"
    end

    def period
      self.class.name.split('::').last
    end

    def has_genre?(genre) # rubocop:disable Naming/PredicateName
      @genres.include? genre unless @movies_collection.filter(genres: genre).count.zero?
    end

    def month
      return if @r_date.count('-').zero?
      Date::MONTHNAMES[Date.strptime(@r_date, '%Y-%m').month]
    end

    def matches?(field, filter)
      raise "Doesn't have field \"#{field}\"!" unless ATTRIBUTES.include? field
      movie_field = send(field)
      if movie_field.is_a?(Array)
        movie_field.any? { |obj| filter === obj }
      else
        filter === movie_field
      end
    end

    def attrs
      ATTRIBUTES
    end
  end
end