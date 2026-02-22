require_relative "./Mp"

class NaturalMpRegen
  attr_reader :natural_mp_regen

  @@initial_natural_mp_regen = 5
  def initialize(natural_mp_regen: nil)
    @natural_mp_regen = natural_mp_regen || @@initial_natural_mp_regen
  end

  def regenerate(mp)
    throw "Error: the target is not from Mp class, target is #{mp.class}" unless mp.is_a? Mp

    mp.add_mp(@natural_mp_regen)
  end
end