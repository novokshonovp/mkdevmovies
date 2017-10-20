require_relative "cinema"
require 'time'
class Theatre < Cinema
  SCHEDULE = {6..12 => {period: ["AncientMovie"]},12..18 =>  {genres: ["Comedy","Adventure"]}, 18..24 => {genres: ["Drama","Horror"]}}
 
  def show(time)
    the_time = Time.parse(time) 
    raise "Cinema closed!" if !SCHEDULE.any?{|key, value| key === the_time.hour} 
    movies = Array.new
    SCHEDULE.select{|time, filter| time === the_time.hour}.values.first.each{|key,value| 
                     movies += self.filter((key.to_sym) => (Regexp.new value.join("|"))) }
    super(movies.sort_by { |movie| rand * movie.rating.to_i }.first, the_time)  
  end
  
  def when?(title)      
      schedule = SCHEDULE.select{|time, filter| filter.any?{|key,value| 
                                                              !self.filter(title: title).first.send(key).is_a?(Array) ?  movie_field = self.filter(title: title).first.send(key).to_s.split : 
                                                                                                           movie_field = self.filter(title: title).first.send(key)  
                                                              (movie_field & value).any? }}
      schedule.empty? ? (raise "No schedule for #{title}!") : "#{title}: " + schedule.keys.join(",")
  end
end