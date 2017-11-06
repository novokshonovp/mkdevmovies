
class AncientMovie < Movie
  def to_s
    "<<#{@title} - Ancient movie (#{@r_year}).>>"
  end
end
class ClassicMovie < Movie
  def to_s
    films = @movies_collection.filter(director: @director) 
    directors_movies_count_adds = '(other '+(films.count-1).to_s+' movies in the list)' if films.count>1
    "<<#{@title} - Classic movie, director: #{@director}#{directors_movies_count_adds}.>>"
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