require 'time'
require_relative 'cinema'
require_relative 'cashbox'
require_relative 'schedule'

module MkdevMovies
  class Theatre < Cinema
    include CashBox
    include Schedule

    def show(time)
      the_time = Time.parse(time)
      movies = find_movies(the_time)
      super(mix(movies).first, the_time)
    end

    private def find_movies(time)
      _, schedule = find_schedule(time)
      get_movies_by_schedule(schedule)
    end

    private def get_movies_by_schedule(schedule)
      schedule[:title].nil? ? filter(schedule[:filters]) : filter(title: schedule[:title])
    end

    def when?(movie_title)
      schedule = get_schedule_by_title(movie_title)
      raise "No schedule for #{movie_title}!" if schedule.empty?
      "#{movie_title}: " + schedule.keys.join(',')
    end

    def get_schedule_by_title(movie_title)
      movie = filter(title: movie_title).first
      schedule_internal.select do |_time, filter|
        next true unless filter[:title].nil?
        filter[:filters].all? do |key, value|
          movie.matches?(key, value)
        end
      end
    end

    def buy_ticket(time)
      the_time = Time.parse(time)
      _, schedule = find_schedule(the_time)
      price = schedule[:price]
      put_cash(price)
      movie = mix(get_movies_by_schedule(schedule)).first
      puts "You bought the #{Money.from_amount(price, :USD).format} ticket for #{movie.title}."
    end
  end
end
