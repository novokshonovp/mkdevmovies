require_relative "cinema"
require 'time'
class Theatre < Cinema
  SCHEDULE = {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Drama","Horror"]}} 
  
  def schedule
    SCHEDULE
  end  
  def schedule_internal
    schedule.transform_values{|filter| filter.transform_values(&Regexp.method(:union)) }
  end
  def show(time)
    the_time = Time.parse(time) 
    movie_filters = schedule_internal.select{|time, filter| time === the_time.hour}.values.first
    raise "Cinema closed!" if movie_filters.nil?
    movies = filter(movie_filters)
    super(mix(movies).first,the_time)  
  end
  
  def when?(title)    
      movie  = filter(title: title).first
      schedule = schedule_internal.select{|time, filter| filter.all?{|key,value| 
                                                              movie.matches?(key,value) }}  
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(",")
  end
end