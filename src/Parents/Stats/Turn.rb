class Turn
  attr_reader :current_turn

  @@initial_turn = 1
  def initialize(amount: nil)
    @current_turn = amount || @@initial_turn
  end

  def set_turn(amount)
    @current_turn = amount
  end

  # operator overload if Turn - Turn
  # @param amount [Integer] the amount of turns to be subtracted
  def -(amount)
    @current_turn -= amount
  end

  # operator overload if Turn + Turn
  def +(amount)
    @current_turn += amount
  end
end