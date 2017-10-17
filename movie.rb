 class Movie
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
  def to_s
  "\"#{@title}\", #{@rating}, #{@director}, #{@r_year}, #{@r_date}, #{@runtime}, #{@country}, genres: #{@genres.join(", ")}, stars: #{@actors.join(", ")}"
  end
  def period
    self.class.to_s
  end
  def has_genre?(genre)
    if @movies_collection.filter(genres: genre).count.zero?
      raise "Wrong the genre - \"#{genre}\" in \"has_genre\" method's parameter!"
    end
    @genres.include? genre
  end
  def month
     if !@r_date.count('-').zero?
      Date::MONTHNAMES[Date.strptime(@r_date,"%Y-%m").month]
     end                 
  end
  def matches?(field,filter) 
    if self.send(field).is_a?(Array)
        self.send(field).any? {|obj| filter === obj}
    else
      filter === self.send(field)
    end
  end
  def attrs
    ATTRIBUTES
  end
end
class AncientMovie < Movie
  def to_s
    "<<#{@title} - Ancient movie (#{@r_year}).>>"
  end
end
class ClassicMovie < Movie
  def to_s
    @films = @movies_collection.filter(director: @director).map{|movie| movie.title} 
    @films.delete(@title)
    "<<#{@title} - Classic movie, director: #{@director}#{('('+@films.join(', ')+')') if @films.count>0}.>>"
  end
end
class ModernMovie < Movie
  def to_s
    "<<#{@title} - Modern movie, stars: #{@actors.join(', ')}.>>"
  end
end
class NewMovie < Movie
  def to_s
    "<<#{@title} - New movie, released #{Date.today.year-@r_year} years ago.>>"
  end
end