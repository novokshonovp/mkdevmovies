require 'date'

 class Movie
 require_relative 'movie_children'
  PERIODS = {1900..1945 => AncientMovie, 1946..1968 => ClassicMovie, 1969..2000 => ModernMovie, 2001..Date.today.year => NewMovie }
  ATTRIBUTES = %i[ link title r_year country r_date genres runtime rating director actors period]
  attr_reader *ATTRIBUTES
  def initialize(movie,movie_collection)
    @movies_collection =  movie_collection
    @link = movie.link
    @title = movie.title
    @r_year = movie.r_year.to_i
    @country = movie.country
    @r_date = movie.r_date
    @genres = movie.genres.split(",")
    @runtime = movie.runtime.to_i 
    @rating = movie.rating
    @director = movie.director
    @actors = movie.actors.split(",")
  end
  def create(movie)
    raise "Wrong period to create movie!" if PERIODS.detect{|period, movie_class| period.cover?(movie.r_year.to_i) }.nil?
    PERIODS.detect{|period, movie_class| period.cover?(movie.r_year.to_i) }.last.new(movie,self)
  end
  def to_s
  "\"#{@title}\", #{@rating}, #{@director}, #{@r_year}, #{@r_date}, #{@runtime}, #{@country}, genres: #{@genres.join(", ")}, stars: #{@actors.join(", ")}"
  end
  def period
    self.class.to_s
  end
  
  def has_genre?(genre)

    @genres.include? genre if !@movies_collection.filter(genres: genre).count.zero?
  end
  
  def month
     if !@r_date.count('-').zero?
      Date::MONTHNAMES[Date.strptime(@r_date,"%Y-%m").month]
     end                 
  end
  
  def matches?(field,filter) 
    raise "Doesn't have field \"#{field}\"!" if !ATTRIBUTES.include? field
    movie_field = send(field)
    if movie_field.is_a?(Array)
       movie_field.any? {|obj| filter === obj} 
    else
      filter === movie_field
    end   
  end
  
  def attrs
    ATTRIBUTES
  end
end
