require "Parents/Actionable/Turnable"

class AddTurn
    attr_accessor :amount

    # @param amount [Integer] the amount of turns to be added
    def initialize(amount)
        @amount = amount
    end

    # @param turnable [Turnable] the turnable instance to apply the add turn action to
    def apply_to(turnable)
        throw "Error: turnable must be an instance of Turnable, got #{turnable.class}" unless turnable.is_a? Turnable

        turnable.increase_turn_amount(@amount)
    end
end