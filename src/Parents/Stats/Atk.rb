class Atk
  attr_reader :base_atk_modifiers, :atk_modifiers

  @@initial_atk = 10
  def initialize(amount: nil)
    @base_atk = amount || @@initial_atk

    # @type [Array<Proc>]
    @base_atk_modifiers = []

    # @type [Array<Proc>]
    @atk_modifiers = []
  end

  # this is used for display purpose
  def atk_colorized
    base_atk = @base_atk
    atk = self.atk
    dif = atk - base_atk

    if dif > 0
      return "#{self.atk.to_s.colorize(:yellow)} (#{"+#{dif.to_s}".colorize(:green)})"
    elsif dif < 0
      return "#{self.atk.to_s.colorize(:yellow)} (#{dif.to_s.colorize(:red)})"
    else
      return self.atk.to_s.colorize(:yellow)
    end
  end

  def base_atk
    base_atk = @base_atk

    @base_atk_modifiers.each do |modifier|
      base_atk = modifier.call(base_atk)
    end

    return base_atk.to_i
  end

  def atk
    atk = self.base_atk

    @atk_modifiers.each do |modifier|
      atk = modifier.call(atk)
    end

    return atk.to_i
  end
end