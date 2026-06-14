require "Parents/Stats/Mp"

class NaturalMpRegen
  attr_reader :base_natural_mp_regen_modifiers, :natural_mp_regen_modifiers
  @@initial_natural_mp_regen = 5

  # @param natural_mp_regen [Integer]
  def initialize(amount: nil)
    @base_natural_mp_regen = amount || @@initial_natural_mp_regen

    # @type [Array<Proc>]
    @base_natural_mp_regen_modifiers = []

    # @type [Array<Proc>]
    @natural_mp_regen_modifiers = []
  end

  # @param mp [Mp]
  # @return [void]
  def regenerate(mp)
    throw "Error: the target is not from Mp class, target is #{mp.class}" unless mp.is_a? Mp

    mp.add_mp(self.natural_mp_regen)
  end

  # @return [String] the regen value in colorized format, shows +/- when modified from base
  def natural_mp_regen_colorized
    regen = self.natural_mp_regen
    base_speed = @base_natural_mp_regen
    dif = regen - base_speed

    if dif > 0
      return "#{regen.to_s.colorize(:cyan)} (#{"+#{dif.to_s}".colorize(:green)})"
    elsif dif < 0
      return "#{regen.to_s.colorize(:cyan)} (#{dif.to_s.colorize(:red)})"
    else
      return regen.to_s
    end
  end

  def base_natural_mp_regen
    base_nmpr = @base_natural_mp_regen

    @base_natural_mp_regen_modifiers.each do |modifier|
      base_nmpr = modifier.call(base_nmpr)
    end

    return base_nmpr.to_i
  end

  def natural_mp_regen
    nmpr = self.base_natural_mp_regen

    @natural_mp_regen_modifiers.each do |modifier|
      nmpr = modifier.call(nmpr)
    end

    return nmpr.to_i
  end
end