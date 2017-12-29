require_relative 'moviecollection'
module Mkdevmovies
  class Cinema < MovieCollection
    private

    def show(movie, time = Time.now)
      puts "<<Now showing #{movie.title} #{time.strftime('%H:%M')} - " \
           "#{(time + movie.runtime * 60).strftime('%H:%M')}>>"
    end

    def mix(movies)
      movies.sort_by { |movie| rand * movie.rating.to_i }
    end
  end
end
