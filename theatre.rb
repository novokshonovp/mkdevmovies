require_relative "cinema"
require 'time'
class Theatre < Cinema
  SCHEDULE = {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Drama","Horror"]}} 
  SCHEDULE_INTERNAL = SCHEDULE.transform_values{|filter| filter.transform_values(&Regexp.method(:union)) }
  def show(time)
    the_time = Time.parse(time) 
    _, filters = SCHEDULE_INTERNAL.detect{ |time, _| time.cover?(the_time.hour) }
    raise "Cinema closed!" if filters.nil?
    movies = filter(filters)
    super(mix(movies).first,the_time)  
  end
  
  def when?(title)    
      movie  = filter(title: title).first
      schedule = SCHEDULE_INTERNAL.select{|time, filter| filter.all?{|key,value| 
                                                              movie.matches?(key,value) }}  
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(",")
  end
end