require 'time'
require_relative 'cinema'
require_relative 'cashbox'
module MkdevMovies
  class Theatre < Cinema
    include CashBox
    SCHEDULE = { 6..12 => { period: ['AncientMovie'] }, 12..18 => { genres: %w[Comedy Adventure] },
                 18..24 => { genres: %w[Drama Horror] } }.freeze
    SCHEDULE_INTERNAL = SCHEDULE.transform_values do |filter|
      filter.transform_values(&Regexp.method(:union))
    end
    PRICE = { 6..12 => 3, 12..18 => 5, 18..24 => 10 }.freeze
    def show(time)
      the_time = Time.parse(time)
      movies = find_movies(the_time)
      super(mix(movies).first, the_time)
    end

    private def find_movies(time)
      _, filters = SCHEDULE_INTERNAL.detect { |schedule_time, _| schedule_time.cover?(time.hour) }
      raise 'Cinema closed!' if filters.nil?
      filter(filters)
    end

    def when?(title)
      movie = filter(title: title).first
      schedule = SCHEDULE_INTERNAL.select do |_time, filter|
        filter.all? do |key, value|
          movie.matches?(key, value)
        end
      end
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(',')
    end

    def buy_ticket(time)
      the_time = Time.parse(time)
      movie = mix(find_movies(the_time)).first
      _, price = PRICE.detect { |price_time, _| price_time.cover?(the_time.hour) }
      put_cash(price)
      puts "You bought the #{Money.from_amount(price, :USD).format} ticket for #{movie.title}."
    end
  end
end