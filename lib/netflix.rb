require_relative 'cinema'
require_relative 'cashbox'
module MkdevMovies
  class FilterCinema
    attr_reader :user_filters
    def initialize(cinema)
      @user_filters = {}
      @cinema = cinema
    end

    def field_keys(filters)
      field_filters = filters.dup
      field_filters.reject! { |key, _value| @user_filters.key?(key) }
      field_filters
    end

    def user_keys(filters)
      (filters.to_a - field_keys(filters).to_a).to_h
    end

    def add_user_filter(filter_name, from: false, arg: false, &filter_code)
      user_filters.merge!(filter_name => { from: from, arg: arg, proc: filter_code })
    end

    def by_field_keys(movies, filters)
      field_filters_keys = field_keys(filters)
      field_filters_keys.empty? ? movies : @cinema.filter(field_filters_keys)
    end

    def by_user_keys(movies, filters)
      user_filters_keys = user_keys(filters)
      return movies if user_filters_keys.empty?
      movies_filtered = movies.dup
      user_filters_keys.each_key do |key, _value|
        next if user_filters_keys[key] == false
        movies_filtered.select! do |movie|
          if user_filters[key][:from]
            fx = user_filters[user_filters[key][:from]][:proc].curry.call(movie)
            fx.call(user_filters[key][:arg])
          else
            user_filters[key][:proc].call(movie, *user_filters_keys[key])
          end
        end
      end
      movies_filtered
    end

    def by_codeblock(movies)
      block_given? ? movies.select { |movie| yield(movie) } : movies
    end
  end

  class Netflix < Cinema
    extend CashBox
    PRICES = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze
    attr_reader :user_balance, :key_filter
    def initialize(filename_zip, filename_txt)
      @user_balance = Money.new(0, :USD)
      @key_filter = FilterCinema.new(self)
      super(filename_zip, filename_txt)
    end

    def pay(amount)
      raise 'Amount should be positive!' if amount <= 0
      @user_balance += Money.from_amount(amount, :USD)
      Netflix.put_cash(amount)
    end

    def how_much?(title)
      Money.from_amount(PRICES[filter(title: title).first.period.to_sym], :USD)
    end

    def show(**filters, &codeblock)
      movies = key_filter.by_field_keys(@movies, filters)
      movies = key_filter.by_user_keys(movies, filters)
      movies = key_filter.by_codeblock(movies, &codeblock)
      raise "Nothing to show. Change a block's filter options." if movies.empty?
      movie_to_show = mix(movies).first
      pay_for_movie(movie_to_show)
      super(movie_to_show)
    end

    def pay_for_movie(movie)
      raise 'Not enough money!' if @user_balance < how_much?(movie.title)
      @user_balance -= how_much?(movie.title)
    end

    def define_filter(filter_name, from: false, arg: false, &filter_code)
      @key_filter.add_user_filter(filter_name, from: from, arg: arg, &filter_code)
    end
  end
end
