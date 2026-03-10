class Matk
  attr_accessor :matk_amount

  @@initial_matk = 10

  # @param amount [Integer]
  def initialize(amount: nil)
    @matk_amount = amount || @@initial_matk
  end

  # @return [String] the matk amount in colorized format
  def matk_colorized
    @matk_amount.to_s.colorize(:purple)
  end
end