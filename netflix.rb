require_relative "cinema"
require_relative "cashbox"
module MkdevMovies
  class Netflix < Cinema
    extend CashBox
    PRICES = {AncientMovie: 1, ClassicMovie: 1.5, ModernMovie: 3, NewMovie: 5}
    attr_reader :user_balance
    def initialize(filename_zip, filename_txt)
      @user_balance=Money.new(0, :USD)
      super(filename_zip, filename_txt)
    end
    def pay(amount)
      raise "Amount should be positive!"  if amount<=0
      @user_balance+=Money.from_amount(amount, :USD)
      Netflix.put_cash(amount)
    end 
    def how_much?(title)
      Money.from_amount(PRICES[filter(title: title).first.period.to_sym], :USD)
    end
    def show(**filters) 
      movies = filter(filters)
      movie_to_show = mix(movies).first
      raise "Not enough money!"if @user_balance< how_much?(movie_to_show.title)
      @user_balance-= how_much?(movie_to_show.title)
      super(movie_to_show)  
    end
  end
end