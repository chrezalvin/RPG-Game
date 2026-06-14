require "Parents/Creature"

class Speed
    attr_reader :base_speed_modifiers, :speed_modifiers

    # @param speed [Integer]
    def initialize(amount: nil)
        @base_speed = amount || 1
        # @type [Array<Proc>]
        @base_speed_modifiers = []

        # @type [Array<Proc>]
        @speed_modifiers = []
    end

    # calculates the amount of turns based of own speed and opponent's speed.
    # @param creature [Creature] the creature to calculate turn order for
    def calculate_turns(creature)
        throw "creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

        
        # use computed speeds
        my_speed = self.speed
        opponent_speed = creature.speed.speed

        turns = (my_speed.to_f / opponent_speed.to_f).floor.to_i
        turns = 1 if turns < 1

        return turns
    end
    
    # @return [String] the speed in colorized format, shows +/- when modified from base
    def speed_colorized
        speed = self.speed
        base_speed = @base_speed
        dif = speed - base_speed

        if dif > 0
            return "#{speed.to_s.colorize(:yellow)} (#{"+#{dif.to_s}".colorize(:green)})"
        elsif dif < 0
            return "#{speed.to_s.colorize(:yellow)} (#{dif.to_s.colorize(:red)})"
        else
            return speed.to_s.colorize(:yellow)
        end
    end
    
    def base_speed
        base_speed = @base_speed

        @base_speed_modifiers.each do |modifier|
            base_speed = modifier.call(base_speed)
        end

        return base_speed.to_i
    end

    def speed
        speed = self.base_speed

        @speed_modifiers.each do |modifier|
            speed = modifier.call(speed)
        end

        return speed.to_i
    end
end