require_relative 'moviecollection'
class Cinema < MovieCollection
PRICES = {AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5}
@@balance=0
  def initialize (filename_zip, filename_txt)
    super(filename_zip, filename_txt)
  end
  def balance
    @@balance
  end
   def pay(amount)
    raise "Amount should be positive!"  if amount<0.01 
    @@balance+=amount
  end 
  def how_much?(title)
    PRICES[self.filter(title: title).first.class.to_s.to_sym]
  end
  def show(title)
    (@@balance< how_much?(title)) ? (raise "Not enough money!")  : @@balance-=how_much?(title)
    movie = filter(title: title)
    "<<Now showing #{title} #{Time.now.strftime("%H:%M")} - #{(Time.now + movie.first.runtime*60).strftime("%H:%M")}>>"    
  end
end