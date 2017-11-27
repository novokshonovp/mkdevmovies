require 'time'
require_relative 'cinema'
require_relative 'cashbox'
require_relative 'schedule'

module MkdevMovies
  class Theatre < Cinema
    include CashBox
    include Schedule

    def show(time)
      tm = Time.parse(time)
      movies = find_movies(tm)
      super(mix(movies).first, tm)
    end

    private def find_movies(time)
      period = get_period_by_time(time)
      validate_period(period)
      filter(period.parse_filter)
    end

    def when?(movie_title)
      periods = get_periods_by_title(movie_title)
      raise "No schedule for #{movie_title}!" if periods.empty?
      "#{movie_title}: #{periods.map(&:time_range).join(',')}"
    end

    private def get_periods_by_title(movie_title)
      movie = filter(title: movie_title).first
      @schedule.select do |period|
        filters = period.parse_filter
        filters.all? { |key, value| movie.matches?(key, value) }
      end
    end

    def buy_ticket(time, hall: false)
      tm = Time.parse(time)
      period = hall == false ? get_period_by_time(tm) : get_period_by_time_and_hall(tm, hall)
      validate_period(period)
      price = period.params[:price]
      put_cash(price)
      movie = mix(filter(period.parse_filter)).first
      puts "You bought the #{Money.from_amount(price, :USD).format} ticket for #{movie.title}."
    end

    def validate_period(period)
      raise 'Cinema closed!' if period.nil?
    end
  end
end
