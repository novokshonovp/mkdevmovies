require 'time'
require_relative "cinema"
require_relative "cashbox"

class Theatre < Cinema
  include CashBox
  SCHEDULE = {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Drama","Horror"]}} 
  SCHEDULE_INTERNAL = SCHEDULE.transform_values{|filter| filter.transform_values(&Regexp.method(:union)) }
  PRICE = {6..12 => 3, 12..18 => 5, 18..24 => 10}
  def show(time)
    the_time = Time.parse(time)
    movies = find_movies(the_time)
    super(mix(movies).first, the_time)  
  end
  
  private def find_movies(time) 
    _, filters = SCHEDULE_INTERNAL.detect{ |schedule_time, _| schedule_time.cover?(time.hour) }
    raise "Cinema closed!" if filters.nil?  
    filter(filters)
  end
  
  def when?(title)    
      movie  = filter(title: title).first
      schedule = SCHEDULE_INTERNAL.select{|time, filter| filter.all?{|key,value| 
                                                              movie.matches?(key,value) }}  
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(",")
  end
  
  def buy_ticket(time)
    the_time = Time.parse(time)
    movie = mix(find_movies(the_time)).first
    _, price = PRICE.detect{ |time, _| time.cover?(the_time.hour) }
    put_cash(price)
    puts "You bought the #{Money.from_amount(price,:USD).format} ticket for #{movie.title}."
  end
end