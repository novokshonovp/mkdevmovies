 class Movie
  ATTRIBUTES = %i[ link title r_year country r_date genres runtime rating director actors]
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
  def has_key?(value,key) 
    if Array === self.send(value) 
        self.send(value).map {|obj| key === obj}.any?
    else
      key === self.send(value)
    end
  end
  def attrs
    ATTRIBUTES
  end
end