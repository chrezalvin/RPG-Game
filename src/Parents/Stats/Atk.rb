class Atk
  attr_accessor :atk_amount, :initial_atk

  @@initial_atk = 10
  def initialize(amount: nil)
    @atk_amount = amount || @@initial_atk
  end

  def atk_colorized
    @atk_amount.to_s.colorize(:yellow)
  end
end