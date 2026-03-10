require "Parents/Stats/Matk"

RSpec.describe Matk do
  context "when initialized with amount 18" do
    amount = 18
    matk = Matk.new(amount: amount)

    after(:each) do
      amount = matk.matk_amount
    end

    it 'expects matk_amount is valid' do
      expect(matk.matk_amount).to eq amount
    end

    it 'provides a colorized string' do
      expect(matk.matk_colorized).to be_a String
    end
  end

  context "when initialized without amount" do
    matk = Matk.new

    it 'defaults to initial matk value' do
      expect(matk.matk_amount).to be_a Integer
    end
  end
end
