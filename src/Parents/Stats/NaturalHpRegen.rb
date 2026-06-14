require "Parents/Stats/Hp"

class NaturalHpRegen

  @@initial_natural_hp_regen = 5

  # @param natural_hp_regen [Integer]
  def initialize(amount: nil)
    @base_natural_hp_regen = amount || @@initial_natural_hp_regen

    # @type [Array<Proc>]
    @base_natural_hp_regen_modifiers = []

    # @type [Array<Proc>]
    @natural_hp_regen_modifiers = []
  end

  # @param hp [Hp]
  # @return [void]
  def regenerate(hp)
    throw "Error: the target is not from Hp class, target is #{hp.class}" unless hp.is_a? Hp

    hp.heal(self.natural_hp_regen)
  end

  def base_natural_hp_regen
    base_natural_hp_regen = @base_natural_hp_regen

    @base_natural_hp_regen_modifiers.each do |modifier|
      base_natural_hp_regen = modifier.call(base_natural_hp_regen)
    end

    return base_natural_hp_regen.floor.to_i
  end

  def natural_hp_regen
    natural_hp_regen = self.base_natural_hp_regen

    @natural_hp_regen_modifiers.each do |modifier|
      natural_hp_regen = modifier.call(natural_hp_regen)
    end

    return natural_hp_regen.floor.to_i
  end

  # @return [String] the regen value in colorized format, shows +/- when modified from base
  def natural_hp_regen_colorized
    natural_hp_regen = self.natural_hp_regen
    base_natural_hp_regen = @base_natural_hp_regen
    dif = natural_hp_regen - base_natural_hp_regen

    if dif > 0
      return "#{natural_hp_regen.to_s.colorize(:pink)} (#{"+#{dif.to_s}".colorize(:green)})"
    elsif dif < 0
      return "#{natural_hp_regen.to_s.colorize(:pink)} (#{dif.to_s.colorize(:red)})"
    else
      return natural_hp_regen.to_s.colorize(:pink)
    end
  end
end