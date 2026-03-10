require "Parents/Stats/Atk"

RSpec.describe Atk do
  context "when initialized with amount 25" do
    amount = 25
    atk = Atk.new(amount: amount)

    after(:each) do
      amount = atk.atk_amount
    end

    it 'expects atk_amount is valid' do
      expect(atk.atk_amount).to eq amount
    end

    it 'provides a colorized string' do
      expect(atk.atk_colorized).to be_a String
    end
  end

  context "when initialized without amount" do
    atk = Atk.new

    it 'defaults to initial atk value' do
      expect(atk.atk_amount).to be_a Integer
    end
  end
end
