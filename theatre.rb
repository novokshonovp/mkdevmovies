require_relative "cinema"
require 'time'
class Theatre < Cinema
  SCHEDULE = {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Drama","Horror"]}} 
  SCHEDULE_INTERNAL = SCHEDULE.transform_values{|filter| filter.transform_values(&Regexp.method(:union)) }
                                                                
  def show(time)
    the_time = Time.parse(time) 
    movie_filters = SCHEDULE_INTERNAL.select{|time, filter| time === the_time.hour}.values.first
    raise "Cinema closed!" if movie_filters.nil?
    movies = filter(movie_filters)
    super(mix(movies).first,the_time)  
  end
  
  def when?(title)    
      movie  = filter(title: title).first
      schedule = SCHEDULE.select{|time, filter| filter.any?{|key,value| 
                                                              movie.send(key).is_a?(Array) ?  movie_field = filter(title: title).first.send(key) : 
                                                                                              movie_field = filter(title: title).first.send(key).to_s.split
                                                              (movie_field & value).any? }}
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(",")
  end
end