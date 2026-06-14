class MpUse
    attr_reader :mp_used

    # @param use_amount [Integer] the amount of mp used
    # @param user [Creature, nil] the creature that uses mp
    def initialize(use_amount, is_effect = true)
        throw "Error: use_amount must be an Integer, got #{use_amount.class}" unless use_amount.is_a? Integer

        @mp_used = use_amount

        @use_type = "unknown"
        @is_effect = is_effect
    end

    # @return [Integer] the amount of mp used
    def mp_used
        mp_used = @mp_used

        return mp_used.to_i
    end

    def mp_used_colorized
        self.mp_used.to_s.colorize(:light_blue)
    end
end