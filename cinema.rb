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
  def show(title, time)
    start_movie(title,time)
  end
  def show_prepayed(title)
    (@balance< how_much?(title)) ? (raise "Not enough money!")  : @balance-=how_much?(title)  
    start_movie(title, Time.now)
  end
  def start_movie(title, time)
    movie = filter(title: title)
    puts "<<Now showing #{title} #{time.strftime("%H:%M")} - #{(time + movie.first.runtime*60).strftime("%H:%M")}>>"  
  end
end