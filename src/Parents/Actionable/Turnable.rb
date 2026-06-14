require "utils/Event"
require "Parents/Stats/Turn"
require "Parents/ActionProfile/UseTurn"
require "Parents/ActionProfile/AddTurn"
require "Parents/ActionProfile/SetTurn"

class Turnable
    attr_reader :on_before_turn_start, 
        :on_after_turn_start,
        :on_before_turn_end, 
        :on_after_turn_end,
        :on_before_turn_added, 
        :on_after_turn_added, 
        :on_before_turn_reduced, 
        :on_after_turn_reduced, 
        :on_turn_amount_change
        
    # @param turn [Turn] the turn instance that this creature is currently in
    def initialize(turn)
        throw "Error: turn must be an instance of Turn, got #{turn.class}" unless turn.is_a? Turn

        @turn = turn

        @on_before_turn_start = Event.new()
        @on_after_turn_start = Event.new()
        @on_before_turn_end = Event.new()
        @on_after_turn_end = Event.new()

        @on_before_turn_added = Event.new()
        @on_after_turn_added = Event.new()
        @on_before_turn_reduced = Event.new()
        @on_after_turn_reduced = Event.new()

        @on_turn_amount_change = Event.new()
    end

    def start_turn
        @on_before_turn_start.emit()

        @on_after_turn_start.emit()
    end

    def end_turn
        @on_before_turn_end.emit()

        @turn.set_turn(0)

        @on_after_turn_end.emit()
    end

    # @param amount [Integer] the new turn amount to be set
    def set_turn_amount(set_turn)
        @turn.set_turn(set_turn.amount)

        @on_turn_amount_change.emit(@turn.current_turn)
    end

    # @param use_turn [UseTurn] the use turn action to be applied
    def reduce_turn_amount(use_turn)
        @on_before_turn_reduced.emit(use_turn)

        @turn - use_turn.amount

        @on_after_turn_reduced.emit(use_turn)
        @on_turn_amount_change.emit(@turn.current_turn)
    end

    # @param add_turn [AddTurn] the add turn action to be applied
    def increase_turn_amount(add_turn)
        @on_before_turn_added.emit(add_turn)

        @turn + add_turn.amount

        @on_after_turn_added.emit(add_turn)
        @on_turn_amount_change.emit(@turn.current_turn)
    end
end