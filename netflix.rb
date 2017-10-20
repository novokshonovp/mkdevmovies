require_relative "cinema"
class Netflix < Cinema
  def show(**filters) 
    raise "Wrong filter params!" if !filters.keys.all?{ |filter_name| self.attrs.include?(filter_name) } 
    movies = self.filter(filters)
    raise "No movies found!" if movies.empty?
    show_prepayed(movies.sort_by { |movie| rand * movie.rating.to_i }.first)  
  end
end
