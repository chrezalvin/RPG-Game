class Dodge
    attr_reader :base_dodge_modifiers, :dodge_modifiers

    @@min_accuracy_chance_percentage = 20

    # @param dodge [Integer]
    def initialize(amount: nil)
        @base_dodge = amount || 1

        # @type [Array<Proc>]
        @base_dodge_modifiers = []

        # @type [Array<Proc>]
        @dodge_modifiers = []
    end

    # @return [String] the dodge value in colorized format, shows +/- when modified from base
    def dodge_colorized
        dodge = self.dodge
        base_dodge = @base_dodge
        dif = dodge - base_dodge

        if dif > 0
            return "#{dodge.to_s.colorize(:cyan)} (#{"+#{dif.to_s}".colorize(:green)})"
        elsif dif < 0
            return "#{dodge.to_s.colorize(:cyan)} (#{dif.to_s.colorize(:red)})"
        else
            return dodge.to_s
        end
    end

    def base_dodge
        base_dodge = @base_dodge

        @base_dodge_modifiers.each do |modifier|
            base_dodge = modifier.call(base_dodge)
        end

        return base_dodge.to_i
    end

    def dodge
        dodge = self.base_dodge

        @dodge_modifiers.each do |modifier|
            dodge = modifier.call(dodge)
        end

        return dodge.to_i
    end
end