class Atk
  attr_accessor :atk_amount

  @@initial_atk = 10
  def initialize(amount = @@initial_atk)
    @atk_amount = amount
  end
end