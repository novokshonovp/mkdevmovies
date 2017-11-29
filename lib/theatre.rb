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
      period = period_by_time(time, nil)
      filter(period.parse_filter)
    end

    def when?(movie_title)
      periods = periods_by_title(movie_title)
      raise "No schedule for #{movie_title}!" if periods.empty?
      "#{movie_title}: #{periods.map(&:time_range).join(',')}"
    end

    private def periods_by_title(movie_title)
      movie = filter(title: movie_title).first
      @schedule.select do |period|
        filters = period.parse_filter
        filters.all? { |key, value| movie.matches?(key, value) }
      end
    end

    def buy_ticket(time, hall: nil)
      tm = Time.parse(time)
      period = period_by_time(tm, hall)
      price = period.params[:price]
      put_cash(price)
      movie = mix(filter(period.parse_filter)).first
      puts "You bought the #{Money.from_amount(price, :USD).format} ticket for #{movie.title}."
    end
  end
end
