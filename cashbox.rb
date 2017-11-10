require 'money'
I18n.enforce_available_locales = false

module CashBox

  private def balance
    @balance ||= Money.new(0, :USD)
  end
  
  def cash
    balance
  end
  
  def put_cash(amount)
    raise "Amount should be positive!" if amount<=0
    @balance = balance.nil? ? Money.new(0, :USD) : @balance+Money.from_amount(amount, :USD)
  end
  
  def take(who)
    raise "Police!" if who != "Bank"
    puts "Cash withdrawn. #{balance.format}"
    @balance = Money.new(0, :USD)
  end
end
