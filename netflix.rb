require_relative "cinema"
class Netflix < Cinema
  
  def initialize(filename_zip, filename_txt) 
    super(filename_zip, filename_txt)
  end
  
  def show(**filters) 
    raise "Wrong filter params!" if !filters.keys.all?{ |filter_name| self.attrs.include?(filter_name) } 
    movies = self.filter(filters)
    raise "No movies found!" if movies.count == 0
    super(movies.sort_by { |movie| rand * movie.rating.to_i }.first.title)  
  end
end
