require_relative "cinema"
class Netflix < Cinema
  PRICES = {AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5}
  attr_reader :balance
  def initialize(filename_zip, filename_txt)
    @balance=0
    super(filename_zip, filename_txt)
  end
  def pay(amount)
    raise "Amount should be positive!"  if amount<0.01 
    @balance+=amount
  end 
  def how_much?(title)
    PRICES[filter(title: title).first.class.to_s.to_sym]
  end
  def show(**filters) 
    raise "Wrong filter params!" if !filters.keys.all?{ |filter_name| attrs.include?(filter_name) } 
    movies = filter(filters)
    raise "No movies found!" if movies.empty?
    movie_to_show = mix(movies).first
    raise "Not enough money!"if @balance< how_much?(movie_to_show.title)
    @balance-= how_much?(movie_to_show.title)
    super(movie_to_show)  
  end
end