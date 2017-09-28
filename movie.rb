class Movie
  ATTRIBUTES = [:link, :title, :r_year, :country, :r_date, :genres, :runtime, :rating, :director, :actors]
  attr_reader *ATTRIBUTES
  def initialize(movie,movie_collection)
    @movies_collection =  movie_collection
    @link = movie.link
    @title = movie.title
    @r_year = movie.r_year
    @country = movie.country
    @r_date = movie.r_date
    @genres = movie.genres.split(",")
    @runtime = movie.runtime.scan(/[0-9]/).join.to_i 
    @rating = movie.rating
    @director = movie.director
    @actors = movie.actors.split(",")
    return
  end
  def to_s
  "\"#{@title}\", #{@rating}, #{@director}, #{@r_date}, #{@runtime}, #{@country}, genres: #{@genres.join(", ")}, stars: #{@actors.join(", ")}"
  end
  def has_genre?(genre)
    if @genres.include? genre 
      true
    elsif !@movies_collection.filter(genres: genre).count.zero?
      false
    else
      raise "Wrong the genre - \"#{genre}\" in \"has_genre\" method's parameter!"
    end  
  end
  def attrs
    ATTRIBUTES
  end
end