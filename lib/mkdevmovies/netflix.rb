require_relative 'cinema'
require_relative 'cashbox'
require_relative 'filtercinema'
module Mkdevmovies
  class Netflix < Cinema
    extend CashBox
    PRICES = { AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5 }.freeze
    attr_reader :user_balance, :key_filter
    def initialize
      @user_balance = Money.new(0, :USD)
      @key_filter = FilterCinema.new(self)
      super
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
      movies = key_filter.apply(@movies, filters, &codeblock)
      raise "Nothing to show. Change a block's filter options." if movies.empty?
      movie_to_show = mix(movies).first
      pay_for_movie(movie_to_show)
      super(movie_to_show)
    end

    def pay_for_movie(movie)
      raise 'Not enough money!' if @user_balance < how_much?(movie.title)
      @user_balance -= how_much?(movie.title)
    end

    def define_filter(filter_name, from: nil, arg: nil, &filter_code)
      @key_filter.add_user_filter(filter_name, from: from, arg: arg, &filter_code)
    end
  end
end
