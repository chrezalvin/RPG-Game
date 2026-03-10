require "Parents/Stats/Defense"
require "Parents/Damage"

RSpec.describe Defense do
  context "when initialized with defense 5" do
    defense_value = 5
    defense = Defense.new(defense: defense_value)

    it 'reduces damage by defense amount' do
      damage = Damage.new(20, nil)

      defense.apply_defense(damage)

      expect(damage.damage).to eq 15
    end

    it 'never reduces damage below 0' do
      damage = Damage.new(1, nil)

      defense.apply_defense(damage)

      expect(damage.damage).to eq 0
    end

    it 'raises when passed non-damage' do
      expect { defense.apply_defense(123) }.to raise_error(UncaughtThrowError)
    end
  end
end
