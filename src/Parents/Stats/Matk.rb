class Matk
  attr_accessor :matk_amount, :initial_matk

  @@initial_matk = 10
  def initialize(amount: nil)
    @matk_amount = amount || @@initial_matk
  end
end