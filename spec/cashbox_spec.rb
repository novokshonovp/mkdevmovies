require './cashbox'
require 'money'


describe CashBox do
  let(:dummytheatre) { Class.new { include CashBox} }
  let(:cash_box) { cash_box = dummytheatre.new }

  describe "#put_cash" do
    subject { cash_box.put_cash(amount) }
    context "when negative" do
      let(:amount) { -1 }
      it { expect{ subject }.to raise_error "Amount should be positive!" }
    end
    context "when positive" do
      let(:amount) { 3.55 }
      it { expect{ subject }.to change(cash_box, :cash).by(Money.from_amount(amount, :USD)) }
    end
  end

  describe ".take" do
    before { cash_box.put_cash(balance) }
    subject { cash_box.take(who) }
    let(:balance) { 155.12 }    
    context "when bank" do
      let(:who) { "Bank" }
      it { expect{ subject }.to  output("Cash withdrawn. #{Money.from_amount(balance,:USD).format}\n").to_stdout }
      it { expect{ subject }.to  change(cash_box, :cash).to(Money.new(0, :USD)) }
    end
    context "when alarm" do
      let(:who) { "thief" }
      it { expect{ subject }.to  raise_error "Police!" }
    end
  end
  
  describe ".cash" do
    subject { cash_box.cash.amount }
    context "when init" do
      it { expect(subject).to eq 0 }
    end
    context "when has money" do
      before { cash_box.put_cash(amount) }
      let(:amount) { 10 }
      it {expect(subject).to eq amount }
    end
  end
end