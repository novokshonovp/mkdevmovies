require_relative "cinema"
require 'time'
class Theatre < Cinema
  SCHEDULE_PERIODS = {AncientMovie: 6..12}
  SCHEDULE_GENRES= { Comedy: 12..18, Adventure: 12..18, Drama: 18..24, Horror: 18..24}
   def initialize (filename_zip, filename_txt)
    super(filename_zip, filename_txt)
  end
  
  def show(time)
    the_time = Time.parse(time)
    if SCHEDULE_PERIODS.any?{ |key,value| value === the_time.hour }
      filter_name = SCHEDULE_PERIODS.select{ |key,value| value === the_time.hour }.keys
      movies = self.filter(period: (Regexp.new filter_name.join("|")))
    elsif SCHEDULE_GENRES.any?{ |key,value| value === the_time.hour }
      filter_name = SCHEDULE_GENRES.select{ |key,value| value === the_time.hour }.keys
      movies = self.filter(genres: (Regexp.new filter_name.join("|")))
    else
       raise "Cinema closed!"
    end
    super(movies.sort_by { |movie| rand * movie.rating.to_i }.first.title)  
  end
  
  def when?(title)      
      schedule = (SCHEDULE_PERIODS.select {|key,value| key.to_s === self.filter(title: title).first.period}.values +
                  SCHEDULE_GENRES.select {|key,value| self.filter(title: title).first.genres.any?{|genre| genre==key.to_s}}.values).uniq.join(',')
       raise "No schedule for #{title}!" if schedule.empty? 
       "#{title}: " + schedule
  end
end