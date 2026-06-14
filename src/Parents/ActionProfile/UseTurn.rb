require "Parents/Actionable/Turnable"

class UseTurn
    attr_accessor :amount

    # @param amount [Integer] the amount of turns to be used
    def initialize(amount)
        @amount = amount
    end
end