require_relative 'cinema'
module MkdevMovies
  class FilterCinema
    attr_reader :user_filters
    def initialize(cinema)
      @user_filters = {}
      @cinema = cinema
    end

    def add_user_filter(filter_name, from: nil, arg: nil, &filter_code)
      filter_code = ->(*movie) { user_filters[from].call(*movie, *arg) } if from
      user_filters[filter_name] = filter_code
    end

    def apply(movies, filters, &codeblock)
      user_filters, field_filters = filters.partition do |key, _value|
        @user_filters.key?(key)
      end.map(&:to_h)
      movies_filtered = by_field(movies, field_filters)
      movies_filtered = by_user(movies_filtered, user_filters)
      by_codeblock(movies_filtered, &codeblock)
    end

    private

    def by_field(movies, filters)
      filters.empty? ? movies : @cinema.filter(filters)
    end

    def by_user(movies, filters)
      filters.select { |_, value| value }
             .reduce(movies) do |movies_filtered, filter|
        block = user_filters[filter.first]
        movies_filtered.select do |movie|
          filter.last == true ? block.call(movie) : block.call(movie, *filters[filter.first])
        end
      end
    end

    def by_codeblock(movies)
      block_given? ? movies.select { |movie| yield(movie) } : movies
    end
  end
end
