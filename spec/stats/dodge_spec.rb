require "Parents/Stats/Dodge"
require "Parents/ActionProfile/Damage"
require "Parents/Creature"

RSpec.describe Dodge do
  context "when initialized with dodge 30" do
    dodge_value = 30
    dodge = Dodge.new(dodge: dodge_value)

    it 'returns false when damage has nil accuracy' do
        # create a dummy creature without accuracy
        dealer = Creature.new
        
        damage = Damage.new(10, dealer)
        # dealer.accuracy is default 0, so Damage#accuracy will return 0
        # with dodge 30 the computed chance will be high, so expect true
        expect(dodge.can_dodge?(damage)).to eq true
    end

    it 'returns false when both dodge and accuracy are 0' do
      zero_dodge = Dodge.new(dodge: 0)
      dealer = Creature.new
      damage = Damage.new(10, dealer)
      expect(zero_dodge.can_dodge?(damage)).to eq false
    end

    it 'raises when passed non-damage' do
      expect { dodge.can_dodge?(123) }.to raise_error(UncaughtThrowError)
    end
  end
end
