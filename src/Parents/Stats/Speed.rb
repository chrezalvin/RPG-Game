require "Parents/Creature"

class Speed
    attr_accessor :speed

    # @param speed [Integer]
    def initialize(speed: nil)
        @speed = speed || 1
    end

    # calculates the amount of turns based of own speed and opponent's speed.
    # @param creature [Creature] the creature to calculate turn order for
    def calculate_turns(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        opponent_speed = creature.speed.speed

        turns = (self.speed.to_f / opponent_speed.to_f).floor.to_i
        turns = 1 if turns < 1

        return turns
    end
end