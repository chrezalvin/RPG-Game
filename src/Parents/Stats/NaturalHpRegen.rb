require "Parents/Stats/Hp"

class NaturalHpRegen
  attr_accessor :natural_hp_regen

  @@initial_natural_hp_regen = 5

  # @param natural_hp_regen [Integer]
  def initialize(natural_hp_regen: nil)
    @natural_hp_regen = natural_hp_regen || @@initial_natural_hp_regen
  end

  # @param hp [Hp]
  # @return [void]
  def regenerate(hp)
    throw "Error: the target is not from Hp class, target is #{hp.class}" unless hp.is_a? Hp

    hp.heal(@natural_hp_regen)
  end
end