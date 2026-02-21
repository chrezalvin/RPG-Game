require_relative "./Hp"

class NaturalHpRegen
  attr_reader :natural_hp_regen, :initial_natural_hp_regen

  @@initial_natural_hp_regen = 5
  def initialize(natural_hp_regen: nil)
    @natural_hp_regen = natural_hp_regen || @@initial_natural_hp_regen
  end

  def regenerate(hp)
    if hp.is_a? Hp
      hp.heal(@natural_hp_regen)
    else
      throw "Error: the target is not from Hp class, target is #{hp.class}"
    end
  end
end