require_relative 'moviecollection'
class Cinema < MovieCollection
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
    PRICES[self.filter(title: title).first.class.to_s.to_sym]
  end
  def show(movie, time)
    start_movie(movie,time)
  end
  def show_prepayed(movie)
    (@balance< how_much?(movie.title)) ? (raise "Not enough money!")  : @balance-=how_much?(movie.title)  
    start_movie(movie, Time.now)
  end
  def start_movie(movie, time)
    puts "<<Now showing #{movie.title} #{time.strftime("%H:%M")} - #{(time + movie.runtime*60).strftime("%H:%M")}>>"  
  end
end