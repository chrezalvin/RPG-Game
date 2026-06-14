class Defense
    attr_reader :base_defense_modifiers, :defense_modifiers

    # @param defense [Integer]
    def initialize(amount: nil)
        @base_defense = amount || 0

        # @type [Array<Proc>]
        @base_defense_modifiers = []

        # @type [Array<Proc>]
        @defense_modifiers = []
    end

    def defense_colorized
        defense = self.defense
        base_speed = @base_defense
        dif = defense - base_speed

        if dif > 0
            return "#{defense.to_s.colorize(:blue)} (#{"+#{dif.to_s}".colorize(:green)})"
        elsif dif < 0
            return "#{defense.to_s.colorize(:blue)} (#{dif.to_s.colorize(:red)})"
        else
            return defense.to_s.colorize(:blue)
        end
    end

    def base_defense
        base_defense = @base_defense

        @base_defense_modifiers.each do |modifier|
            base_defense = modifier.call(base_defense)
        end

        return base_defense.to_i
    end

    def defense
        defense = self.base_defense

        @defense_modifiers.each do |modifier|
            defense = modifier.call(defense)
        end

        return defense.to_i
    end
end