class Matk
  attr_accessor :matk_amount 
  attr_reader :base_matk_modifiers, :matk_modifiers

  @@initial_matk = 10

  # @param amount [Integer]
  def initialize(amount: nil)
    @base_matk = amount || @@initial_matk

    # @type [Array<Proc>]
    @base_matk_modifiers = []

    # @type [Array<Proc>]
    @matk_modifiers = []
  end

  # @return [String] the matk amount in colorized format
    def matk_colorized
      matk = self.matk
      base_matk = @base_matk
      dif = matk - base_matk

      if dif > 0
        return "#{matk.to_s.colorize(:purple)} (#{"+#{dif.to_s}".colorize(:green)})"
      elsif dif < 0
        return "#{matk.to_s.colorize(:purple)} (#{dif.to_s.colorize(:red)})"
      else
        return matk.to_s.colorize(:purple)
      end
  end

  def base_matk
    base_matk = @base_matk

    @base_matk_modifiers.each do |modifier|
      base_matk = modifier.call(base_matk)
    end

    return base_matk.to_i
  end

  def matk
    matk = self.base_matk

    @matk_modifiers.each do |modifier|
      matk = modifier.call(matk)
    end

    return matk.to_i
  end
end